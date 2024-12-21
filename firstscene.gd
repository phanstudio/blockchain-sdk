extends Node2D

#var contract_manager : ContractManager
#const precompiled_contract = preload("res://addons/blockchain_sdk/precompilers/address.gd")
#
#func onclick():
	#contract_manager = Web3Global.contract_manager
	#var address = precompiled_contract.ADDRESS_PRECOMPILE_ADDRESS
	#var abi = precompiled_contract.ADDRESS_PRECOMPILE_ABI
	#var contract = contract_manager.smartcontract(address, abi)
	#var logs = await contract_manager.runsafely(
		#contract.getSeiAddr,
		#["0xa604362acaAe026a0D326DFaeD506186D1C145C8"],
	#)
	#if logs:
		#contract_manager.console.log(logs)
	#else: # handel error
		#pass
	##logs = await contract_manager.runsafely(
		##contract.getEvmAddr,
		##["sei1zjxfju4vjwu3gx5famk57njx52wtc056se6xsh"],
	##)
	##if logs:
		##contract_manager.console.log(logs)
	##else:
		##pass
		

var contract_manager : ContractManager
const DragonswapRouter = preload("res://testing/DragonswapRouter.gd")

func onclick():
	contract_manager = Web3Global.contract_manager
	var address = DragonswapRouter.DRAGONSWAPROUTER_ADDRESS
	var abi = DragonswapRouter.DRAGONSWAPROUTER_ABI
	var contract = contract_manager.smartcontract(address, abi)
	var logs = await contract_manager.runsafely(
		contract.WSEI,
	)
	if logs:
		contract_manager.console.log(logs)
	else: # handel error
		pass
