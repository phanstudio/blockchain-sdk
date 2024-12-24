extends Node
class_name CoinFlipContract

var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager

func _init() -> void:
	var address = '0xb33a6b046c5152737ed46ae2c14bb04de497bd28'
	var abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_coinFlipAddr",
				"type": "address"
			}
		],
		"name": "coinFlipGuess",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "consecutiveWins",
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
		"inputs": [],
		"name": "FACTOR",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]
	contract = contract_manager.smartcontract(address, abi)

func coinFlipGuess(_coinFlipAddr: String) -> int:
	var logs = await contract_manager.runsafely(
		contract.coinFlipGuess,
		[_coinFlipAddr]
	)
	if logs != null:
		contract_manager.console.log(logs)
		return logs
	printerr("Error calling coinFlipGuess")
	return 0

func consecutiveWins() -> int:
	var logs = await contract_manager.runsafely(
		contract.consecutiveWins,
	)
	if logs != null:
		contract_manager.console.log(logs)
		return logs
	printerr("Error calling consecutiveWins")
	return 0

func FACTOR() -> int:
	var logs = await contract_manager.runsafely(
		contract.FACTOR,
	)
	if logs != null:
		contract_manager.console.log(logs)
		return logs
	printerr("Error calling FACTOR")
	return 0
