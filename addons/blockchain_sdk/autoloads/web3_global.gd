@tool
extends Node

#@export var DEFAULT_NODE_URL: String# = "https://evm-rpc.arctic-1.seinetwork.io"
#const DEFAULT_NODE_URL = "https://evm-rpc.arctic-1.seinetwork.io"

var wallet_manager: Wallet
var contract_manager: ContractManager

#var wallet_address: String = "" # make global
#var is_wallet_connected: bool = false
#var accounts = []

func _ready():
	wallet_manager = Wallet.new()
	contract_manager = ContractManager.new()
	
	add_child(wallet_manager)
	add_child(contract_manager)
	
	#blockchain.init(DEFAULT_NODE_URL)
