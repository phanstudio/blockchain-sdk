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

func coinFlipGuess(_coinFlipAddr: String) -> void:
	var logs = await contract_manager.runsafely(
		contract.coinFlipGuess,
		[_coinFlipAddr],"execute"
	)
	assert(
		logs != contract_manager.ERROR, 
		"ERROR: An error occured while calling getSeiAddr"
	);

func consecutiveWins() -> int:
	var logs = await contract_manager.runsafely(
		contract.consecutiveWins,[],
	)
	contract_manager.console.log(logs.toString())
	assert(
		logs != contract_manager.ERROR, 
		"ERROR: An error occured while calling getSeiAddr"
	);
	return logs

func FACTOR() -> int:
	var logs = await contract_manager.runsafely(
		contract.FACTOR,[],
	)
	assert(
		logs != contract_manager.ERROR, 
		"ERROR: An error occured while calling getSeiAddr"
	);
	return logs
