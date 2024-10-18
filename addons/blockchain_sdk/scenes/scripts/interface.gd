@tool
extends MarginContainer

@onready var connectbutton = %ConnectButton
@onready var AmountLabel = %AmountLabel
@onready var AddressLabel = %AddressLabel
@onready var wallet = Web3Global.wallet_manager

@export var addresstext := "":
	set(new_text):
		set_text(AddressLabel, new_text)
		addresstext = new_text
	get: 
		return get_text(AddressLabel)

@export var amounttext := "":
	set(new_text):
		set_text(AmountLabel, new_text)
		amounttext = new_text
	get: 
		return get_text(AmountLabel)

@export var connecttext := "":
	set(new_text):
		set_text(connectbutton, new_text)
		connecttext = new_text
	get: 
		return get_text(connectbutton)

func _ready():
	if OS.has_feature("web"):
		wallet.connect("wallet_connected", _on_wallet_connected)
		wallet.connect("wallet_disconnected", _on_wallet_disconnected)
		wallet.connect("balance_updated", _update_balance)
		#wallet.connect("wallet_error", _on_wallet_error)
	connectbutton.connect("pressed", connect_wallet)
	_update_wallet_ui(false)

func set_text(control, new_value):
	if control:
		control.text = new_value

func get_text(control) -> String:
	if control:
		return control.text
	return ""

func connect_wallet() -> void:
	if wallet.is_wallet_connected:
		wallet.disconnect_wallet()
	else:
		wallet.connect_wallet()

func _on_wallet_connected(address: String) -> void:
	_update_wallet_ui(true)

func _on_wallet_disconnected() -> void:
	_update_wallet_ui(false)

func _update_balance(balance: String) -> void:
	amounttext = "Balance: " + balance + " SEI"
	pass

func _update_wallet_ui(connected: bool) -> void:
	if connected:
		connecttext = "Disconnect Wallet"
		addresstext = "Address: " + wallet.wallet_address
	else:
		connecttext = "Connect Wallet"
		addresstext = "Address: "
	AddressLabel.visible = connected
	AmountLabel.visible = connected

func _show_only_values():
	connecttext = "Disconnect Wallet"
	addresstext = "Address: " + wallet.wallet_address
	amounttext = "Balance: " + wallet.balance + " SEI"
	connectbutton.visible = false
	AddressLabel.visible = true
	AmountLabel.visible = true

#inpage.js:1 MetaMask - RPC Error: Already processing eth_requestAccounts. Please wait. {code: -32002, message: 'Already processing eth_requestAccounts. Please wait.', stack: '{\n  "code": -32002,\n  "message": "Already processi…ogaeaoehlefnkodbefgpgknn/background-4.js:3:48032)'}
