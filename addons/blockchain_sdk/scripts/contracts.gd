extends JsWeb3Node
class_name ContractManager

signal contract_created(address: String)
signal contract_query_result(result)
signal contract_execution_result(result)

var checklogs
var safereject
var jsreturnvalue

var query_contract = JavaScriptBridge.create_callback(_query_contract)
var execute_contract = JavaScriptBridge.create_callback(_execute_contract)
var wait = JavaScriptBridge.create_callback(_wait)
var sign_returned = JavaScriptBridge.create_callback(_sign_returned)
var sign_error = JavaScriptBridge.create_callback(_sign_error)

var safeerror = JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		safereject = response
)
var jsreturn = JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		jsreturnvalue = response
)

func _ready():
	super._ready()

# create contract
func smartcontract(contract_address, contract_abi):
	contract_abi = Json.stringify(contract_abi)
	var javascript_code = """
		const contract = new ethers.Contract(
			"%s",
			%s,
			window.signer
		);
		window.contract = contract // for testing
	""" % [contract_address, contract_abi]
	JavaScriptBridge.eval(javascript_code)
	contract = window.contract
	console.log(contract)
	delete_globals("contract")
	return contract

# view/read contract (response)
func _query_contract(args):
	var response = args[0] if args.size() > 0 else null
	window.console.log(response)

#func arr_to_str(arr:Array):
	#var string_array = PackedStringArray(arr)
	#var string = ", ".join(string_array)
	#return string

#func str_to_address(lstring):
	#return "(address)"+lstring

func arr_to_str(arr:Array):
	var s = ""
	for value in arr:
		match typeof(value):
			TYPE_STRING:
				if value.replace("n", "").is_valid_int(): # big number
					s += ('%s, '%[value])
				#elif value.begins_with("(address)"): # big number
					#s += ('"%s", '%[value]).replace("(address)", "")
				else:
					s += ('"%s", '%[value]) # might change
			TYPE_NIL:
				s += ('%s, '%[value]).replace("<null>", "null")
			_:
				s += (' %s, '%[value])
		
	s = s.substr(0, s.length()-2)
	return s

func create_big_obj(dicts: Dictionary):
	var s = "{ "
	for i in dicts.keys():
		var value = dicts[i]
		match typeof(value):
			TYPE_STRING:
				if value.replace("n", "").is_valid_int(): # big number
					s += ('%s : %s, '%[i, value])
				else:
					s += ('%s : "%s", '%[i, value])
			TYPE_NIL:
				s += ('%s : %s, '%[i, value]).replace("<null>", "null")
			_:
				s += ('%s : %s, '%[i, value])
		
	s = s.substr(0, s.length()-2)
	s += " }"
	return s

func read_big_obj(s: String) -> Dictionary:
	s = s.strip_edges().trim_prefix("{").trim_suffix("}")
	var result = {}
	# Split into key-value pairs
	var pairs = s.split(",")
	for pair in pairs:
		if ":" in pair:
			var kv = pair.split(":")
			var key = kv[0].strip_edges()
			var value = kv[1].strip_edges()
		# Try to convert value to number if possible
			if value.is_valid_int():
				value = value.to_int()
			elif value.is_valid_float():
				value = value.to_float()
			elif value == "true":
				value = true
			elif value == "false":
				value = false
			elif value == "null":
				value = null
			elif "\"" in value:
				value.replace("\"", "")
			result[key] = value
	return result

func create_jsobj(dicts: Dictionary):
	var s = create_big_obj(dicts)
	var javascript_code = """
	window.result = %s
	"""%[s]
	JavaScriptBridge.eval(javascript_code)
	var result = window.result
	delete_globals("result")
	return result

func runsafely(contractmethod, args1:Array=[], _method:String= "query"): # execute or query
	var args:String = arr_to_str(args1)
	window.contractmethod = contractmethod.estimateGas
	var argument_dict = read_big_obj(args.split(", ")[-1])
	var error = {}
	var runlogs
	error["willFail"] = true
	error["gasEstimate"] = null
	if not Web3Global.wallet_manager.is_wallet_connected:
		error["error"] = "wallet not connected"
	elif "value" in argument_dict:
		var bet_amount = parseBigNumToNumber(argument_dict["value"])
		if bet_amount > Web3Global.wallet_manager.wallet_balance:
			if 0 == Web3Global.wallet_manager.wallet_balance:
				error["error"] = "amount in wallet is 0"
			else:
				error["error"] = "bet amount is greater than amount in wallet"
		else:
			error = false
	else:
		error = false
	if error:
		error = create_jsobj(error)
	if not error:
		var javascript_code = """
			async function checkWillFailAsync() {
				try {
					const gasEstimate = await window.contractmethod(%s);
					return {
						willFail: false,
						error: null,
						gasEstimate: gasEstimate.toString()
					};
				} catch (error) {
					return {
						willFail: true,
						error: error.message,
						gasEstimate: null
					};
				}
			}
		window.result = checkWillFailAsync
		"""%[args]
		JavaScriptBridge.eval(javascript_code);
		await wait_till(window.result().then(jsreturn))
		delete_globals("contractmethod")
		delete_globals("result")
		runlogs = jsreturnvalue
		console.log(runlogs)
	else:
		runlogs = error
	jsreturnvalue = null
	safereject = null
	if runlogs.willFail: # add return values for success
		return runlogs # create a dict error == false if its good
	else:
		await run(contractmethod, args, _method)
		return safereject

func run(_method, args: String, _type: String= "query"): # add contract executed
	window.contractmethod = _method
	var javascript_code = """
		async function run_contract() {
			try {
				let results = await window.contractmethod(%s);
				return results;
			} catch (error) {
				return error.message;
			}
		}
	window.result = run_contract
	"""%[args]
	JavaScriptBridge.eval(javascript_code);
	var execute = query_contract
	if _type == "execute":
		execute = execute_contract
	await wait_till(window.result().then(execute).catch(safeerror)) # add retrive logs option
	delete_globals("contractmethod")
	delete_globals("result")

func parseUnit(number, token_decimals=18):
	number = str(number)
	
	if number.begins_with("."):
		number = "0" + number
		
	var zero_filler = int(token_decimals)
	var decimal_index = number.find(".")
	
	var bignum = number
	if decimal_index != -1:
		var segment = number.right(-(decimal_index+1) )
		zero_filler -= segment.length()
		bignum = bignum.erase(decimal_index,1)

	for zero in range(zero_filler):
		bignum += "0"
	
	var zero_parse_index = 0
	if bignum.begins_with("0"):
		for digit in bignum:
			if digit == "0":
				zero_parse_index += 1
			else:
				break
	if zero_parse_index > 0:
		bignum = bignum.right(-zero_parse_index)

	if bignum == "":
		bignum = "0"

	return bignum+"n"

func parseBigNumToNumber(bignum: String, token_decimals: int = 18):
	bignum = bignum.replace("\"", "")
	# Remove 'n' suffix if present
	bignum = bignum.trim_suffix("n")
	
	# If number is 0, return "0"
	if bignum == "0":
		return float("0")
	
	# Add leading zeros if necessary
	while bignum.length() <= token_decimals:
		bignum = "0" + bignum
		
	# Insert decimal point
	var decimal_position = bignum.length() - token_decimals
	var result = bignum.substr(0, decimal_position) + "." + bignum.substr(decimal_position)
	
	# Remove trailing zeros after decimal
	while result.ends_with("0"):
		result = result.substr(0, result.length() - 1)
		
	# Remove decimal point if it's the last character
	if result.ends_with("."):
		result = result.substr(0, result.length() - 1)
		
	# Remove leading zeros (except if it's a decimal < 1)
	while result.begins_with("0") and result.length() > 1 and result[1] != ".":
		result = result.substr(1)
	
	return float(result)

func delete_globals(varname:String):
	JavaScriptBridge.eval("delete window.%s;"%(varname))

# set/write contract (response)
func _execute_contract(args):
	var response = args[0] if args.size() > 0 else null
	var createPhaseTx = response
	await wait_till(createPhaseTx.wait().then(wait))
	Web3Global.wallet_manager.get_balance()
	# improved version # test this with # execute, wait

# write wait followupResponse (response)
func _wait(args):# normal wait event wait
	var response = args[0] if args.size() > 0 else null
	var createPhaseReceipt = response
	if logs:
		if createPhaseReceipt.logs.length > 0:
			var arr_logs = createPhaseReceipt.logs
			var abiString = createAbiFromFragment(arr_logs[0].fragment)
			var iface = JsNew(_ethers.Interface,create_array([abiString]))
			var decodedLog = iface.parseLog(arr_logs[0]);
			logs = decodedLog.args
			console.log("Phase created with ID:", logs)
	console.log(createPhaseReceipt)

func createAbiFromFragment(fragment):
	var inputs = fragment.inputs.map(JsLambda("input => `${input.type} ${input.name}`")).join(", ");
	return "event %s(%s)"%[fragment.name, inputs];

### Signing:
# still in works
func sign_pressed():
	signer = window.signer
	var msg = "hello world"
	signer.signMessage(msg).then(sign_returned).catch(sign_error)

func _sign_returned(p):
	window.console.log(p[0])
	print(p[0])

func _sign_error(p):
	window.console.log(p[0])
