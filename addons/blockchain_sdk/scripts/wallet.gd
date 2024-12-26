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
var wallet_balance = 0

const SUPPORTED_CHAINS = {
	"ethereum": "0x1",  # Ethereum Mainnet
	"polygon": "0x89",  # Polygon Mainnet
	"Sei": "0x531", # Sei Mainnet
	"Sei-devnet": "0xAE3F3",
	"Sei-testnet": "0x530" # if you have it in your wallet
}

var signer_initialized = JavaScriptBridge.create_callback(_signer_initialized)
var _connects = JavaScriptBridge.create_callback(_connect)
var on_reconnect = JavaScriptBridge.create_callback(_on_reconnect)

var on_reject = JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		is_wallet_connected = false
)
var _updatebalance = JavaScriptBridge.create_callback(
	func(args):
		var response = args[0] if args.size() > 0 else null
		var balance = divide_by_pow10(hex_to_decimal_str(response)).pad_decimals(4)
		wallet_balance = balance.to_float()
		emit_signal("balance_updated", balance)
)

### Wallet: Interacting with the wallet (connect,disconnect,getbalance,switchnetwork,initialize the signer)
func _ready():
	super._ready()

## Conect to the account (Operation)
func connect_wallet() -> void:
	if is_wallet_connected:
		print("Already connecting to wallet. Please wait.")
		return
	if not OS.has_feature("web"):
		emit_signal("wallet_error", "Wallet connection only available in web builds")
		return
	is_wallet_connected = true
	reconnect()

func reconnect():
	await wait_till(window.ethereum.request(
		create_jsobj({
			"method": "wallet_requestPermissions",
			"params": [{"eth_accounts": {}}]
		})
	).then(on_reconnect).catch(on_reject))

func _on_reconnect(args):
	var response = args[0] if args.size() > 0 else null
	is_wallet_connected = false
	await wait_till(window.ethereum.request(
		create_jsobj({
			"method": "eth_requestAccounts"
		})
	).then(_connects).catch(on_reject))
	if is_wallet_connected:
		switch_network("Sei-devnet")
		await wait_till(provider.getSigner().then(signer_initialized))

func _connect(args):
	var response = args[0] if args.size() > 0 else null
	set_accounts(response)

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
	var chain_id = SUPPORTED_CHAINS[chain_name]
	await wait_till(window.ethereum.request(
		create_jsobj({ 
			"method": 'wallet_switchEthereumChain',
			"params": [{"chainId": chain_id}]
		})
	))
	print("switched: ", chain_name)

## Get current wallet balance (Operation)
func get_balance() -> void:
	if not is_wallet_connected:
		emit_signal("connection_failed", "Wallet not connected") # doesn't exist fix
		return
	await wait_till(window.ethereum.request(
		create_jsobj({ 
			"method": 'eth_getBalance',
			"params": [wallet_address, "latest"]
		})
	).then(_updatebalance))

## Setter function (acounts)
func set_accounts(response_array):
	accounts.clear()
	for i in range(response_array.length):
		accounts.push_back(response_array[i])
	if accounts.size():
		wallet_address = accounts[0]
		is_wallet_connected = true
		emit_signal("wallet_connected", accounts[0])
		print(accounts)
		get_balance()

## Intialiaze signer
func _signer_initialized(args):
	var response = args[0] if args.size() > 0 else null
	signer = response
	window.signer = signer
