@tool
extends Node
class_name WalletManager

signal wallet_connected(address: String)
signal wallet_disconnected
signal wallet_error(error: String)

var wallet_address: String = ""
var is_wallet_connected: bool = false
var _onchanged_callback: JavaScriptObject

func _ready():
	if OS.has_feature("web"):
		_onchanged_callback = JavaScriptBridge.create_callback(_on_wallet_changed)
		var window = JavaScriptBridge.get_interface('window')
		window._onchanged_callback = _onchanged_callback

func connect_wallet() -> void:
	if not OS.has_feature("web"):
		emit_signal("wallet_error", "Wallet connection only available in web builds")
		return
		
	var javascript_code = """
	(async () => {
		if (typeof window.ethereum !== 'undefined') {
			try {
				const accounts = await window.ethereum.request({ 
					method: 'eth_requestAccounts' 
				});
				window._onchanged_callback(accounts[0] || 'error: No account selected'); 
			} catch (error) {
				console.log('error: ' + error.message)
			}
		} else {
			console.log('error: No wallet found')
		}
	})();
	"""
	JavaScriptBridge.eval(javascript_code)

func disconnect_wallet() -> void:
	wallet_address = ""
	is_wallet_connected = false
	emit_signal("wallet_disconnected")

func _on_wallet_changed(args: Array) -> void:
	var address = args[0] if args.size() > 0 else null
	if address == null:
		is_wallet_connected = false
		emit_signal("wallet_disconnected")
	else:
		wallet_address = address
		is_wallet_connected = true
		emit_signal("wallet_connected", address)

func get_wallet_address() -> String:
	return wallet_address

func _is_connected() -> bool:
	return is_wallet_connected
