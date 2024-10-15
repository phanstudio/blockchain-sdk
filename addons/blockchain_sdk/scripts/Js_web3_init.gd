@tool
extends Node

class_name JsWeb3Node

var window
var provider
var _ethers
var console
var contract
var signer
var Json = JSON.new()
var logs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("web"):
		window = JavaScriptBridge.get_interface('window')
		_ethers = JavaScriptBridge.get_interface("ethers")
		var javascript_code = """
			window.current_provider = new ethers.BrowserProvider(window.ethereum);
		"""
		JavaScriptBridge.eval(javascript_code);
		provider = JavaScriptBridge.get_interface("current_provider");
		console = window.console

## Utility
func create_array(arr:Array) -> JavaScriptObject:
	var array = JavaScriptBridge.create_object('Array')
	for i in arr:
		array.push(i)
	return array

# wrap the wait_till() function on the promise
# eg: await wait_till(contract.createPhase(2, 1, contract_payment).then(execute_contract))
# this is how you call it
# only works for one then catch iteration, for now 
func wait_till(promise, waittime= 0.1):
	var state = "None"
	while true: 
		state = await PromiseState(promise)
		await get_tree().create_timer(waittime).timeout
		if state in ["fulfilled", "rejected"]:
			break

# use to retrive the logs
# resets logs when used
# eg: var nlogs = await retrieve_logs(contract.createPhase().then(execute_contract))
# add parser for 
func retrieve_logs(operation, waittime= 0.1):
	logs = true
	operation
	while true: 
		await get_tree().create_timer(waittime).timeout
		if logs:
			break
	var log = logs
	logs = false
	return log

func JsLambda(jsstring):
	var javascript_code = """
			window.jslambda = %s
		""" % [jsstring]
	JavaScriptBridge.eval(javascript_code);
	var jslambda = window.jslambda
	window.jslambda = null
	return jslambda

func PromiseState(p):
	window.state_args = p
	var javascript_code = """
		function promiseState(p) {
			const t = {};
			return Promise.race([p, t])
				.then(v => (v === t) ? "pending" : "fulfilled", () => "rejected");
		}

		async function storePromiseResult(p) {
			try {
				const state = await promiseState(p);
				if (state === "pending") {
					window.promisestate = "pending";
				} else if (state === "fulfilled") {
					const value = await p;
					window.promisestate = "fulfilled";
				} else {
					try {
						await p;
					} catch (error) {
						window.promisestate = "rejected";
					}
				}
			} catch (error) {
				console.error("An unexpected error occurred:", error);
				window.promisestate = { state: "error", error };
			}
		}

		// Usage
		storePromiseResult(window.state_args);
	"""
	JavaScriptBridge.eval(javascript_code);
	await get_tree().create_timer(0.05).timeout
	var promise = window.promisestate
	window.promisestate = null
	return promise

func JsNew(new_obj, args):
	window._new_value = new_obj
	window._new_value_args = args
	var javascript_code = """
	window._new_value = new window._new_value(window._new_value_args);
	"""
	JavaScriptBridge.eval(javascript_code)
	var new_value = window._new_value
	window._new_value_args = null
	window._new_value = null
	return new_value
