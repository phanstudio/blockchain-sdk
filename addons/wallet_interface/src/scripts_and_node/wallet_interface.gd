@tool
extends Control

#if event is InputEventKey and event.pressed:
	#if event.keycode == KEY_T:
		#print("T was pressed")

@onready var connected_section = $ConnectedSection
@onready var connect_wallet: PanelContainer = $connect_wallet
@onready var wallet = Web3Global.wallet_manager
@onready var close_section: Panel = $close_section

@export var mainconnectbutton: Array[Control]:
	set(new_value):
		#print(new_value)
		$mainconnectbutton.show()
		if new_value.size() != 0:
			if new_value[0] != $mainconnectbutton:
				$mainconnectbutton.hide()
		mainconnectbutton = new_value
	get:
		return mainconnectbutton

var amount = 0
var address = ""

func _ready() -> void:
	if mainconnectbutton.size() == 0: # reset if nothing in
		mainconnectbutton = [$mainconnectbutton]
	else:
		$mainconnectbutton.hide()
	editvisiblity(mainconnectbutton, true)
	close_connect_section()
	if OS.has_feature("web"):
		wallet.connect("wallet_connected", _on_wallet_connected)
		wallet.connect("wallet_disconnected", _on_wallet_disconnected)
		wallet.connect("balance_updated", _update_balance)
	conncectgroup(mainconnectbutton, "onclick", open_connect_section)
	_update_wallet_ui(wallet.is_wallet_connected)

func editvisiblity(_array:Array, _value=false):
	for i in _array:
		if i:
			if _value:
				i.show()
			else:
				i.hide()

func conncectgroup(_array:Array, _signal: StringName, _callable: Callable, _flags: int = 0):
	for i in _array:
		if i:
			i.connect(_signal, _callable, _flags)

func updategroup(_array:Array, _property: String, _value: Variant):
	var find_property = (func(i, args, v):
		match args:
			"address":
				i.address = v
			"amount":
				i.amount = v
			"connected":
				i.connected = v
	)
	for i in _array:
		if i:
			find_property.call(i, _property, _value)

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
	updategroup(mainconnectbutton, "amount", amount)
	connected_section.amount = amount

func _update_wallet_ui(connected: bool) -> void:
	updategroup(mainconnectbutton, "connected", connected)
	address = wallet.wallet_address if connected else "0x0000000000000"
	updategroup(mainconnectbutton, "address", address)
	connected_section.address = address
	if wallet.wallet_balance != 0: _update_balance(str(wallet.wallet_balance))

func open_connect_section() -> void:
	close_connect_section()
	close_section.show()
	if wallet.is_wallet_connected:
		connected_section.show()
	else:
		connect_wallet.show()

func close_connect_section() -> void:
	close_section.hide()
	connected_section.hide()
	connect_wallet.hide()

func _on_close_section_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		close_connect_section()
