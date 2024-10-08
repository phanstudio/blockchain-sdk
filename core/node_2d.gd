extends Node

@onready var blockchain = $Blockchain
@onready var status_label = $UI/MainColumn/StatusLabel
@onready var balance_label = $UI/MainColumn/BalanceLabel

# Configuration
const NODE_URL = "https://evm-rpc.arctic-1.seinetwork.io"

var wallet_address: String = ""
var is_wallet_connected: bool = false

# Add signals for wallet events
signal wallet_connected(address: String)
signal wallet_disconnected
signal wallet_error(error: String)
var _onchanged_w;


func _ready():
	# Initialize blockchain connection
	blockchain.init(NODE_URL)
	
	# Connect to blockchain signals
	blockchain.connect("request_completed", _on_request_completed)
	blockchain.connect("request_failed", _on_request_failed)
	blockchain.connect("transaction_sent", _on_transaction_sent)
	blockchain.connect("transaction_failed", _on_transaction_failed)

	_onchanged_w = JavaScriptBridge.create_callback(_on_wallet_changed) # js function

# Wallet connection functions
func connect_wallet():
	var javascript_code = """
	(async () => {
		if (typeof window.ethereum !== 'undefined') {
			try {
				const accounts = await window.ethereum.request({ 
					method: 'eth_requestAccounts' 
				}); // eth_accounts
				window._onchanged_w(accounts[0] || 'error: No account selected'); 
			} catch (error) {
				console.log('error: ' + error.message)
			}
		} else {
			console.log('error: No wallet found')
		}
	})();
	"""
	JavaScriptBridge.eval(javascript_code)

func _on_wallet_changed(args):
	var address = args[0] if args.size() > 0 else null
	if address == null:
		is_wallet_connected = false
		_update_wallet_ui(false)
		emit_signal("wallet_disconnected")
	else:
		is_wallet_connected = true
		wallet_address = address
		_update_wallet_ui(true)
		emit_signal("wallet_connected", address)
		query_balance()

func disconnect_wallet():
	wallet_address = ""
	is_wallet_connected = false
	_update_wallet_ui(false)
	emit_signal("wallet_disconnected")

func _update_wallet_ui(connected: bool):
	var wallet_label = $UI/MainColumn/WalletLabel
	var connect_button = $UI/MainColumn/ConnectWallet
	var address_label = $UI/MainColumn/AddressLabel
	var tx_section = $UI/MainColumn/TransactionSection
	
	if connected:
		wallet_label.text = "Wallet: Connected"
		connect_button.text = "Disconnect Wallet"
		address_label.text = "Address: " + wallet_address
		address_label.visible = true
		balance_label.visible = true
		tx_section.visible = true
		query_balance()
	else:
		wallet_label.text = "Wallet: Not Connected"
		connect_button.text = "Connect Wallet"
		address_label.text = "Address: "
		address_label.visible = false
		balance_label.visible = false
		tx_section.visible = false

# Button handlers
func _on_connect_wallet_pressed():
	if is_wallet_connected:
		disconnect_wallet()
	else:
		connect_wallet()

# Example function to query wallet balance
func query_balance() -> void:
	status_label.text = "Querying balance..."
	balance_label.text = "Querying balance..."
	if is_wallet_connected:
		blockchain.query_blockchain(
			{
				"jsonrpc": "2.0",
				"method": "eth_getBalance",
				"params": [wallet_address, "latest"],
				"id": 1
			},
		)


# Example function to send tokens
func send_tokens(recipient: String, amount: String) -> void:
	# This is a simplified example - actual transaction signing would be needed
	var transaction = {
		"from": wallet_address,
		"to": recipient,
		"amount": amount,
		"denomination": "usei"
	}
	
	status_label.text = "Sending transaction..."
	blockchain.send_transaction(JSON.stringify(transaction))

# Signal handlers
func _on_request_completed(response: Dictionary) -> void:
	if "result" in response:
		var hex_balance = response.result
		var balance = hex_balance.substr(2).hex_to_int()
		balance_label.text = "Balance: %s SEI" % str(float(balance) / 1000000000000000000.0) # 10^18
		status_label.text = "Balance updated"

func _on_request_failed(error: String) -> void:
	status_label.text = "Error: " + error
	prints("Request failed:", error)

func _on_transaction_sent(response: Dictionary) -> void:
	status_label.text = "Transaction sent! TxHash: " + response.get("txhash", "unknown")
	# Query balance after transaction
	await get_tree().create_timer(1.0).timeout  # Wait for blockchain to process
	query_balance()

func _on_transaction_failed(error: String) -> void:
	status_label.text = "Transaction failed: " + error
	prints("Transaction failed:", error)

func _on_send_button_pressed() -> void:
	if not is_wallet_connected:
		emit_signal("wallet_error", "Wallet not connected")
		return
	var recipient = $UI/MainColumn/AddressInput.text
	var amount = $UI/MainColumn/AmountInput.text
	if recipient.is_empty() or amount.is_empty():
		status_label.text = "Please enter recipient and amount"
		return
	send_tokens(recipient, amount)

#func _on_send_button_pressed():
	#if not is_wallet_connected:
		#emit_signal("wallet_error", "Wallet not connected")
		#return
		#
	#var recipient = get_node("UI/VBoxContainer/TransactionSection/RecipientInput").text
	#var amount = get_node("UI/VBoxContainer/TransactionSection/AmountInput").text
	#
	#if recipient.is_empty() or amount.is_empty():
		#emit_signal("wallet_error", "Please fill all fields")
		#return
	#
	## Create transaction
	#var transaction = {
		#"from": wallet_address,
		#"to": recipient,
		#"value": amount
	#}
	#
	## If running in browser, request signature
	#if OS.has_feature("JavaScript"):
		#var js_code = """
		#try {
			#const tx = %s;
			#const result = await window.ethereum.request({
				#method: 'eth_sendTransaction',
				#params: [tx],
			#});
			#return result;
		#} catch (error) {
			#return 'error: ' + error.message;
		#}
		#""" % JSON.stringify(transaction)
		#
		#JavaScriptBridge.eval(js_code, true).then(func(result):
			#if str(result).begins_with("error:"):
				#emit_signal("wallet_error", result.substr(7))
			#else:
				#blockchain.send_transaction(result)  # result is the signed transaction
		#)
	#else:
		## For testing in editor
		#blockchain.send_transaction(JSON.stringify(transaction))
