@tool
extends Control

@onready var amount_label: Label = $Connected/ConnectedRow/AmountLabel
@onready var disconnect_button: Button = $Connected/ConnectedRow/DisconnectButton
@onready var connected_node: Array[Node] = [$Connected]
@onready var wallet_manager: Wallet = Web3Global.wallet_manager
var connect_nodes: Array[Node]
@export var use_internal: bool = true

#@export var maincolor: Color = "3652e8" # use color later
@warning_ignore("unused_signal")
signal onclick()

var amount: float = 0.0:
	set(new_value):
		if new_value < 0:
			new_value = 0
		amount = new_value
		if amount_label:
			amount_label.text = str(amount).pad_decimals(2) + " sei"
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
		if connect_nodes and connected_node:
			updategroup(connected_node, "visible", connected)
			updategroup(connect_nodes, "visible", not connected)
	get:
		return connected

func _ready() -> void:
	var group_nodes: Array[Node] = get_tree().get_nodes_in_group("web3dependants")
	connect_nodes = get_tree().get_nodes_in_group("connect_node")
	#connect_nodes.append($Connect)
	if not use_internal:
		if group_nodes.size() > 0: # reset if nothing in
			connected_node.append_array(group_nodes)
	connected = wallet_manager.is_wallet_connected

func updategroup(_array:Array, _property: String, _value: Variant):
	var find_property = (func(i, args, v):
		match args:
			"address":
				i.address = v
			"amount":
				i.amount = v
			"connected":
				i.connected = v
			"visible":
				i.visible = v
	)
	for i in _array:
		if i:
			find_property.call(i, _property, _value)

func button_clicked() -> void:
	emit_signal("onclick")
