@tool
extends EditorPlugin

func _enter_tree():
	# Autoload
	add_autoload_singleton("Web3Global", "res://addons/blockchain_sdk/autoloads/web3_global.gd")
	
	# Custom types
	#add_custom_type("WalletUI", "Control", preload("res://addons/blockchains_sdk/ui/wallet_ui.gd"), preload("res://logo.png"))

func _exit_tree():
	# Clean up
	remove_autoload_singleton("Web3Global")
	#remove_custom_type("WalletUI")
