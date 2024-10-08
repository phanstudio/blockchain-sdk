extends Node2D

func _ready():
	# Access blockchain functionality
	var blockchain = BlockchainGlobal.blockchain
	var wallet_manager = BlockchainGlobal.wallet_manager
	
	# Connect to signals
	wallet_manager.connect("wallet_connected", _on_wallet_connected)
	
	wallet_manager.connect_wallet()
	
	# Use the blockchain
	if wallet_manager._is_connected():
		blockchain.query_blockchain({
			"jsonrpc": "2.0",
			"method": "eth_getBalance",
			"params": [wallet_manager.get_wallet_address(), "latest"],
			"id": 1
		})

func _on_wallet_connected(address: String):
	print("Wallet connected:", address)
