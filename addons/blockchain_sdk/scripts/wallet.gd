# wallet_manager/modules/wallet.gd
extends JsWeb3Node
class_name Wallet

signal wallet_connected(address: String)
signal wallet_disconnected
signal wallet_error(error: String)
signal balance_updated(balance: String)
# add signal to connect wallets

var wallet_address: String = ""
var is_wallet_connected: bool = false
var accounts = []

const SUPPORTED_CHAINS = {
	"ethereum": "0x1",  # Ethereum Mainnet
	"polygon": "0x89",  # Polygon Mainnet
	"Sei": "0x531", # Sei Mainnet
	"Sei-devnet": "0xAE3F3",
	"Sei-testnet": "0x530" # if you have it in your wallet
}

var _confirm_function = JavaScriptBridge.create_callback(_on_confirm)
var signer_initialized = JavaScriptBridge.create_callback(_signer_initialized)

### Wallet: Interacting with the wallet (connect,disconnect,getbalance,switchnetwork,initialize the signer)
func _ready():
	super._ready()
	if OS.has_feature("web"):
		window._confirm_function = _confirm_function

## Conect to the account (Operation)
func connect_wallet() -> void:
	if not OS.has_feature("web"):
		emit_signal("wallet_error", "Wallet connection only available in web builds")
		return
	var javascript_code = """
	(async () => {
		if (typeof window.ethereum !== 'undefined') {
			try {
				const accounts = await window.ethereum.request({ 
					method: 'eth_accounts' 
				});
				window._confirm_function(['connect', accounts]); 
			} catch (error) {
				console.log('error: ' + error.message)
			}
		} else {
			console.log('error: No wallet found')
		}
	})();
	"""
	JavaScriptBridge.eval(javascript_code)
	switch_network("Sei-devnet")
	provider.getSigner().then(signer_initialized)
	#get_balance()
	# create a wait for function for cotracts that need to use them

## disconnect from the account (Operation)
func disconnect_wallet() -> void:
	wallet_address = ""
	is_wallet_connected = false
	emit_signal("wallet_disconnected")
	accounts.clear()

## Switch network (eg. sei mainnet to devnet or eth mainnet) (Operation)
func switch_network(chain_name: String) -> void:
	if not SUPPORTED_CHAINS.has(chain_name):
		emit_signal("connection_failed", "Unsupported chain")
		return
	var ethereum = JavaScriptBridge.get_interface("ethereum")
	var chain_id = SUPPORTED_CHAINS[chain_name]
	
	# Request chain switch
	var params = JSON.stringify([{
		"chainId": chain_id
	}])
	
	var javascript_code = """
	(async () => {
		if (typeof window.ethereum !== 'undefined') {
			try {
				await window.ethereum.request({ 
					method: 'wallet_switchEthereumChain',
					params: %s
				});
				window._confirm_function('switched'); 
			} catch (error) {
				console.log('error: ' + error.message)
			}
		} else {
			console.log('error: No wallet found')
		}
	})();
	""" % [params]
	JavaScriptBridge.eval(javascript_code)

## Get current wallet balance (Operation)
func get_balance() -> void:
	if not is_wallet_connected:
		emit_signal("connection_failed", "Wallet not connected")
		return
	
	var params = Json.stringify([wallet_address, "latest"])
	var javascript_code = """
	(async () => {
		if (typeof window.ethereum !== 'undefined') {
			try {
				const balance = await window.ethereum.request({ 
					method: 'eth_getBalance',
					params: %s
				});
				window._confirm_function(['getbalance', balance]); 
			} catch (error) {
				console.log('error: ' + error.message)
			}
		} else {
			console.log('error: No wallet found')
		}
	})();
	""" % [params]
	JavaScriptBridge.eval(javascript_code)

### Get responses from operations
func _on_confirm(args: Array) -> void:
	var response = args[0] if args.size() > 0 else null
	
	if typeof(response) == TYPE_OBJECT:
		response = [response[0], response[1]]
	else:
		response = [response]
	
	match response[0]:
		"switched":
			print(response[0])
			pass
		"getbalance":
			var balance_wei = "0x" + response[1].trim_prefix("0x")
			var balance = str(balance_wei.hex_to_int() / 1e18).pad_decimals(4)
			print(balance) # set balance
			emit_signal("balance_updated", balance)
		"connect":
			set_accounts(response[1])
		_:
			print("Signal not regstered response %s" % [response[0]])

## Setter function (acounts)
func set_accounts(response_array):
	accounts.clear()
	for i in range(response_array.length):
		accounts.push_back(response_array[i])
	console.log(accounts.size())
	if accounts.size():
		wallet_address = accounts[0]
		is_wallet_connected = true
		emit_signal("wallet_connected", accounts[0])
		print(accounts)
		get_balance()
	
	print(wallet_address)

## Intialiaze signer
func _signer_initialized(args):
	var response = args[0] if args.size() > 0 else null
	signer = response
	window.signer = signer
