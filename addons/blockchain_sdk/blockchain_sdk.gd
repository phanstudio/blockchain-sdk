@tool
extends EditorPlugin

func _enter_tree():
	# Autoload
	add_autoload_singleton("Web3Global", "res://addons/blockchain_sdk/autoloads/web3_global.gd")

func _exit_tree():
	# Clean up
	remove_autoload_singleton("Web3Global")
