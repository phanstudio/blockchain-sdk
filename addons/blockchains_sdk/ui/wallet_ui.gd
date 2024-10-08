@tool
extends Control
class_name WalletUI

@onready var status_label = $MainColumn/StatusLabel
@onready var balance_label = $MainColumn/BalanceLabel
@onready var wallet_label = $MainColumn/WalletLabel
@onready var connect_button = $MainColumn/ConnectWallet
@onready var address_label = $MainColumn/AddressLabel
@onready var tx_section = $MainColumn/TransactionSection

var blockchain: Blockchain
var wallet_manager: WalletManager

func _ready():
	blockchain = BlockchainGlobal.blockchain
	wallet_manager = BlockchainGlobal.wallet_manager
	
	# Connect signals
	blockchain.connect("request_completed", _on_request_completed)
	blockchain.connect("request_failed", _on_request_failed)
	blockchain.connect("transaction_sent", _on_transaction_sent)
	blockchain.connect("transaction_failed", _on_transaction_failed)
	
	wallet_manager.connect("wallet_connected", _on_wallet_connected)
	wallet_manager.connect("wallet_disconnected", _on_wallet_disconnected)
	wallet_manager.connect("wallet_error", _on_wallet_error)
	
	connect_button.connect("pressed", _on_connect_wallet_pressed)
	
	_update_wallet_ui(false)

func _on_connect_wallet_pressed() -> void:
	if wallet_manager._is_connected():
		wallet_manager.disconnect_wallet()
	else:
		wallet_manager.connect_wallet()

func _on_wallet_connected(address: String) -> void:
	_update_wallet_ui(true)
	query_balance()

func _on_wallet_disconnected() -> void:
	_update_wallet_ui(false)

func _update_wallet_ui(connected: bool) -> void:
	if connected:
		wallet_label.text = "Wallet: Connected"
		connect_button.text = "Disconnect Wallet"
		address_label.text = "Address: " + wallet_manager.get_wallet_address()
	else:
		wallet_label.text = "Wallet: Not Connected"
		connect_button.text = "Connect Wallet"
		address_label.text = "Address: "
	address_label.visible = connected
	balance_label.visible = connected
	tx_section.visible = connected

func query_balance() -> void:
	if wallet_manager._is_connected():
		status_label.text = "Querying balance..."
		balance_label.text = "Querying balance..."
		blockchain.query_blockchain({
			"jsonrpc": "2.0",
			"method": "eth_getBalance",
			"params": [wallet_manager.get_wallet_address(), "latest"],
			"id": 1
		})

func _on_request_completed(result: Dictionary) -> void:
	if "result" in result:
		var balance_wei = "0x" + result.result.trim_prefix("0x")
		var balance = str(balance_wei.hex_to_int() / 1e18).pad_decimals(4)
		balance_label.text = "Balance: " + balance + " SEI"
		status_label.text = "Balance updated"

func _on_request_failed(error: String) -> void:
	status_label.text = "Error: " + error

func _on_transaction_sent(response: Dictionary) -> void:
	status_label.text = "Transaction sent!"
	query_balance()

func _on_transaction_failed(error: String) -> void:
	status_label.text = "Transaction failed: " + error

func _on_wallet_error(error: String) -> void:
	print(error)
