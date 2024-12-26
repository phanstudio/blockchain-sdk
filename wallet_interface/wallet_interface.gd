extends Control

@onready var connected_section: PanelContainer = $ConnectedSection
@onready var mainconnectbutton: Control = $mainconnectbutton
@onready var connect_wallet: PanelContainer = $connect_wallet
@onready var wallet = Web3Global.wallet_manager

var amount = 0
var address = ""

func _ready() -> void:
	mainconnectbutton.show()
	connected_section.hide()
	connect_wallet.hide()
	if OS.has_feature("web"):
		wallet.connect("wallet_connected", _on_wallet_connected)
		wallet.connect("wallet_disconnected", _on_wallet_disconnected)
		wallet.connect("balance_updated", _update_balance)
	mainconnectbutton.connect("onclick", open_connect_section)
	_update_wallet_ui(wallet.is_wallet_connected)

func _connect_wallet() -> void:
	close_connect_section() # change later
	if wallet.is_wallet_connected:
		wallet.disconnect_wallet()
	else:
		wallet.connect_wallet()

func _on_wallet_connected(_address: String) -> void:
	_update_wallet_ui(true)

func _on_wallet_disconnected() -> void:
	_update_wallet_ui(false)

func _update_balance(balance: String) -> void:
	amount = float(balance)
	mainconnectbutton.amount = amount
	connected_section.amount = amount

func _update_wallet_ui(connected: bool) -> void:
	mainconnectbutton.connected = connected
	address = wallet.wallet_address if connected else "0x0000000000000"
	mainconnectbutton.address = address
	connected_section.address = address

func open_connect_section() -> void:
	close_connect_section()
	if wallet.is_wallet_connected:
		connected_section.show()
	else:
		connect_wallet.show()

func close_connect_section() -> void:
	connected_section.hide()
	connect_wallet.hide()
