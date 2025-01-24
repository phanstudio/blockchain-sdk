extends PanelContainer

@onready var amount_label: Label = $Body/AmountLabel
@onready var address_label: Label = $Body/AddressContainer/HBoxContainer/AddressLabel
@onready var wallet_manager: Wallet = Web3Global.wallet_manager

# get copy icon and close icon

var amount: float = 0.0:
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
		if address_label:
			address_label.text = wallet_manager.shorten_hex(address)
	get:
		return address

func button_clicked() -> void:
	emit_signal("onclick")

func close_self() -> void:
	self.hide()

func copy_to_clipboard() -> void:
	DisplayServer.clipboard_set(address)
