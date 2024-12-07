extends Node2D

var contract_manager : ContractManager
const precompiled_contract = preload("res://addons/blockchain_sdk/precompilers/address.gd")

func onclick():
	contract_manager = Web3Global.contract_manager
	var address = precompiled_contract.ADDRESS_PRECOMPILE_ADDRESS
	var abi = precompiled_contract.ADDRESS_PRECOMPILE_ABI
	var contract = contract_manager.smartcontract(address, abi)
	await contract_manager.run(
		contract.getSeiAddr,
		contract_manager.arr_to_str(["0xa604362acaAe026a0D326DFaeD506186D1C145C8"]),
	)
