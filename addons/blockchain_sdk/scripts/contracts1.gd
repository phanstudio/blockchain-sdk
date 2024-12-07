# wallet_manager/modules/contract_manager.gd
extends JsWeb3Node
#class_name ContractManager

signal contract_created(address: String)
signal contract_query_result(result)
signal contract_execution_result(result)

var query_contract = JavaScriptBridge.create_callback(_query_contract)
var execute_contract = JavaScriptBridge.create_callback(_execute_contract)
var wait = JavaScriptBridge.create_callback(_wait)

var sign_returned = JavaScriptBridge.create_callback(_sign_returned)
var sign_error = JavaScriptBridge.create_callback(_sign_error)

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

# view/read contract (response)
func _query_contract(args):
	var response = args[0] if args.size() > 0 else null
	#window.console.log(_ethers.toUtf8String(response));
	window.console.log(response)

# set/write contract (response)
func _execute_contract(args):
	var response = args[0] if args.size() > 0 else null
	var createPhaseTx = response
	createPhaseTx.wait().then(wait)

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
