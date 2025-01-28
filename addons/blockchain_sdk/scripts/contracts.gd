extends JsWeb3Node
class_name ContractManager

signal contract_query_result(result)
signal contract_execution_result(result)
signal contract_result # how to check for multiple contracts being ran can multiple contracts be ran

var checklogs
var jsreturnvalue

var query_contract = JavaScriptBridge.create_callback(_query_contract)
var execute_contract = JavaScriptBridge.create_callback(_execute_contract)
var wait = JavaScriptBridge.create_callback(_wait)
const ERROR = "error;"
const OKS = "ok;"
var wait_check = false
var processing = false
var output_logs = {
	"error": null,
	"output": null
}
var safeerror = JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		updateoutput(response)
		wait_check = false
		processing = false
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

## The run methods
func runsafely(contractmethod, args1:Array=[], _method:String= "query"): # execute or query
	if not processing:
		processing = true
		var runlogs
		var args:String = arr_to_str(args1)
		window.contractmethod = contractmethod.estimateGas
		var error = handelDefualtErrors(args)
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
			jsreturnvalue = null
		else:
			runlogs = create_jsobj(error)
		console.log(runlogs) # catch the error
		if not runlogs.willFail: # add return values for success
			await run(contractmethod, args, _method)
			if output_logs["error"] == null:
				# add a delay before this
				return output_logs["output"]
			return ERROR
		processing = false
		updateoutput(runlogs.error)
		return ERROR
	updateoutput("still processing a transaction")
	return ERROR

## add to query contracts add an option for fast/done estimate gas
## when running in fast mode errors might not be caught
func querysafely(contractmethod, args1:Array=[], _fast= false): 
	var _method = "query"
	var runlogs
	var args:String = arr_to_str(args1)
	window.contractmethod = contractmethod.estimateGas
	var error = handelDefualtErrors(args)
	if not _fast:
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
			jsreturnvalue = null
		else:
			runlogs = create_jsobj(error)
	else:
		runlogs = create_jsobj({
			"willFail": false,
			"gasEstimate": null,
			"error": null,
		})
	console.log(runlogs) # catch the error
	if not runlogs.willFail: # add return values for success
		await run(contractmethod, args, _method)
		if output_logs["error"] == null:
			return output_logs["output"]
		return ERROR
	updateoutput(runlogs.error)
	return ERROR

## make run independent from run safely # away to support asynic get functions
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
	if _type == "execute":
		await finishTranscation(window.result().then(execute_contract).catch(safeerror))
	else:
		await wait_till(window.result().then(query_contract).catch(safeerror))
	delete_globals("contractmethod")
	delete_globals("result")

func updateoutput(_error=null, _output=null):
	output_logs["error"] = _error
	output_logs["output"] = _output

func handelDefualtErrors(args: String):
	var argument_dict = read_big_obj(args.split(", ")[-1])
	var error = {
		"willFail": true,
		"gasEstimate": null,
	}
	if not Web3Global.wallet_manager.is_wallet_connected:
		error["error"] = "wallet not connected"
		return error
	elif "value" in argument_dict:
		var _amount = parseBigNumToNumber(argument_dict["value"])
		if _amount > Web3Global.wallet_manager.wallet_balance:
			if 0 == Web3Global.wallet_manager.wallet_balance:
				error["error"] = "amount in wallet is 0"
			else:
				error["error"] = "amount is greater than the amount in wallet"
			return error
	return false

## utilities
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

### contractmethods
## view/read contract (response)
func _query_contract(args):
	var response = args[0] if args.size() > 0 else null
	updateoutput(null, response)
	processing = false

## set/write contract (response)
func _execute_contract(args): #imporve wait to finsh completly
	var response = args[0] if args.size() > 0 else null
	var createPhaseTx = response
	await wait_till(createPhaseTx.wait().then(wait))
	Web3Global.wallet_manager.get_balance()
	wait_check = output_logs["output"]
	#updateoutput(null, OKS) # can be changed
	processing = false
	print(wait_check)
	console.log(wait_check["receipt"])

## wait for transactions to finish
func _wait(args):
	var response = args[0] if args.size() > 0 else null
	var createPhaseReceipt = response
	var wait_dict = {
		"receipt": null
	}
	if createPhaseReceipt.logs.length > 0:
		var arr_logs = createPhaseReceipt.logs
		var abiString = createAbiFromFragment(arr_logs[0].fragment)
		var iface = JsNew(_ethers.Interface,create_array([abiString]))
		var decodedLog = iface.parseLog(arr_logs[0]);
		wait_dict["logs"] = decodedLog.args
		console.log("Phase created with ID:", wait_dict["logs"])
	wait_dict["receipt"] = createPhaseReceipt
	updateoutput(null, wait_dict)

func finishTranscation(operation, waittime= 0.05):
	wait_check = false
	operation
	while true:
		await get_tree().create_timer(waittime).timeout
		if wait_check:
			break
	var log = wait_check
	wait_check = false # reset wait check
	return log

func createAbiFromFragment(fragment):
	var inputs = fragment.inputs.map(JsLambda("input => `${input.type} ${input.name}`")).join(", ");
	return "event %s(%s)"%[fragment.name, inputs];

### Signing:
## still in working progress
func sign_pressed():
	signer = window.signer
	var msg = "hello world"
	var sign_sequence = Sequence.new(_sign_returned, _sign_error, true)
	sign_sequence.runasynic(signer.signMessage(msg))

func _sign_returned(p):
	window.console.log(p)
	print(p)

func _sign_error(p):
	window.console.log(p)
