@tool
extends Node

#@export var DEFAULT_NODE_URL: String# = "https://evm-rpc.arctic-1.seinetwork.io"
const DEFAULT_NODE_URL = "https://evm-rpc.arctic-1.seinetwork.io"

var blockchain: Blockchain
var wallet_manager: WalletManager

func _ready():
	blockchain = Blockchain.new()
	wallet_manager = WalletManager.new()
	
	add_child(blockchain)
	add_child(wallet_manager)
	
	blockchain.init(DEFAULT_NODE_URL)
