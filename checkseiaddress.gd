extends VBoxContainer

@onready var address_label: Label = $row2/address
@onready var line_edit: LineEdit = $row/LineEdit

var address

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func onclick():
	var old_address = line_edit.text
	var contract = PrecompliedAddressContract.new()
	address = await contract.getSeiAddr(old_address)
	address_label.text = "address: "+ address

func copy_to_clipboard() -> void:
	if address:
		DisplayServer.clipboard_set(address)

func prefil_text():
	line_edit.text = Web3Global.wallet_manager.wallet_address
