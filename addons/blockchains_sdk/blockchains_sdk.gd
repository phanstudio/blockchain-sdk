@tool
extends EditorPlugin

func _enter_tree():
	# Autoload
	add_autoload_singleton("BlockchainGlobal", "res://addons/blockchains_sdk/autoloads/blockchain_global.gd")
	
	# Custom types
	add_custom_type("WalletUI", "Control", preload("res://addons/blockchains_sdk/ui/wallet_ui.gd"), preload("res://icon.svg"))

func _exit_tree():
	# Clean up
	remove_autoload_singleton("BlockchainGlobal")
	remove_custom_type("WalletUI")
