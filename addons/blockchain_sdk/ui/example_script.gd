@tool
extends Control
class_name WalletUI

var wallet: Wallet
var contract_manager: ContractManager

func _ready():
	if OS.has_feature("web"):
		wallet = Web3Global.wallet_manager
		contract_manager = Web3Global.contract_manager
		wallet.connect("wallet_connected", _on_wallet_connected)
		wallet.connect("wallet_disconnected", _on_wallet_disconnected)
		wallet.connect("balance_updated", _update_balance)
		#wallet.connect("wallet_error", _on_wallet_error)
	connect_button.connect("pressed", connect_wallet)
	_update_wallet_ui(false)

@onready var status_label = $MainColumn/StatusLabel
@onready var balance_label = $MainColumn/BalanceLabel
@onready var wallet_label = $MainColumn/WalletLabel
@onready var connect_button = $MainColumn/ConnectWallet
@onready var address_label = $MainColumn/AddressLabel
@onready var tx_section = $MainColumn/TransactionSection

func connect_wallet() -> void:
	if wallet.is_wallet_connected:
		wallet.disconnect_wallet()
	else:
		wallet.connect_wallet()

func _on_wallet_connected(address: String) -> void:
	_update_wallet_ui(true)

func _on_wallet_disconnected() -> void:
	_update_wallet_ui(false)

func _update_wallet_ui(connected: bool) -> void:
	if connected:
		wallet_label.text = "Wallet: Connected"
		connect_button.text = "Disconnect Wallet"
		address_label.text = "Address: " + wallet.wallet_address
	else:
		wallet_label.text = "Wallet: Not Connected"
		connect_button.text = "Connect Wallet"
		address_label.text = "Address: "
	address_label.visible = connected
	balance_label.visible = connected
	tx_section.visible = connected

func _update_balance(balance: String) -> void:
	balance_label.text = "Balance: " + balance + " SEI"
	status_label.text = "Balance updated"

func _on_request_failed(error: String) -> void:
	status_label.text = "Error: " + error
