extends Node
class_name StorageContract

var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager

func _init() -> void:
	var address = '0xa78f3cb8851484b2df9f0d362b9f4d952c3c81ab'
	var abi = [
	{
		"inputs": [],
		"name": "retrieve",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "num",
				"type": "uint256"
			}
		],
		"name": "store",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
	]
	contract = contract_manager.smartcontract(address, abi)

func retrieve() -> BigNum:
	var logs = await contract_manager.runsafely(
		contract.retrieve,
		[],
	)
	assert(
		str(logs) != contract_manager.ERROR, 
		"ERROR: An error occured while calling getSeiAddr"
	);
	logs = BigNum.new(logs)
	return logs

func store(num: int) -> void:
	var logs = await contract_manager.runsafely(
		contract.store,
		[num],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR, 
		"ERROR: An error occured while calling getSeiAddr"
	);
