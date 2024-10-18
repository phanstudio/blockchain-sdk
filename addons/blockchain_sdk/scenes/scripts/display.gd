@tool
extends MarginContainer

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

func _ready():
	if OS.has_feature("web"):
		addresstext = "Address: " + wallet.wallet_address
		amounttext = wallet.balance + " SEI"

func set_text(control, new_value):
	if control:
		control.text = new_value

func get_text(control) -> String:
	if control:
		return control.text
	return ""
