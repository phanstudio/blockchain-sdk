extends PanelContainer

@onready var connect_button: Button = $Connect
@onready var amount_label: Label = $Body/AmountLabel
@onready var address_label: Label = $Body/AddressContainer/HBoxContainer/AddressLabel
@onready var wallet_manager: Wallet = Web3Global.wallet_manager
#signal onclick()

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
		if address_label:
			address_label.text = wallet_manager.shorten_hex(address)
	get:
		return address

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

#func shorten_hex(hex_string: String) -> String:
	## Ensure the string is in uppercase and starts with "0x"
	#hex_string = hex_string.strip_edges().to_upper()
	#if not hex_string.begins_with("0X"):
		#hex_string = "0X" + hex_string
#
	## Shorten the string to the first 4 and last 4 characters
	#if len(hex_string) > 10:  # At least "0x" + 8 characters
		#return "%s%s...%s"%[hex_string.substr(0, 4), hex_string.substr(4, 2), hex_string.right(4)]
		##return "{}{}...{}".format(hex_string.substr(0, 4), hex_string.substr(4, 2), hex_string.right(4))
	#else:
		#return hex_string

func button_clicked() -> void:
	emit_signal("onclick")

func close_self() -> void:
	self.hide()
