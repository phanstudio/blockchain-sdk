extends Control

@onready var connect_button: Button = $Connect
@onready var amount_label: Label = $Connected/ConnectedRow/AmountLabel
@onready var disconnect_button: Button = $Connected/ConnectedRow/DisconnectButton
@onready var connected_button: PanelContainer = $Connected
@onready var wallet_manager: Wallet = Web3Global.wallet_manager
signal onclick()

var amount: int = 0:
	set(new_value):
		if new_value < 0:
			new_value = 0
		amount = new_value
		if amount_label:
			amount_label.text = str(amount) + " sei"
	get:
		return amount

var address: String = "":
	set(new_value):
		address = new_value
		if disconnect_button:
			disconnect_button.text = wallet_manager.shorten_hex(address)
	get:
		return address

var connected: bool = false:
	set(new_value):
		connected = new_value
		if connect_button and connected_button:
			connect_button.hide()
			connected_button.hide()
			if connected:
				connected_button.show()
			else:
				connect_button.show()
	get:
		return connected

func _ready() -> void:
	connected = wallet_manager.is_wallet_connected

func button_clicked() -> void:
	emit_signal("onclick")
