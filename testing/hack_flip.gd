extends Node
class_name HackFlipContract

var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager

func _init() -> void:
	var address = '0xD4123BF1567978533DAe2CDA6b868929267eE06C'
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
		[_coinFlipAddr],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getSeiAddr, %s" % 
		[contract_manager.output_logs["error"]]
	);

func consecutiveWins() -> BigNum:
	var logs = await contract_manager.runsafely(
		contract.consecutiveWins,
		[],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getSeiAddr, %s" % 
		[contract_manager.output_logs["error"]]
	);
	logs = BigNum.new(logs)
	return logs

func FACTOR() -> BigNum:
	var logs = await contract_manager.runsafely(
		contract.FACTOR,
		[],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getSeiAddr, %s" % 
		[contract_manager.output_logs["error"]]
	);
	logs = BigNum.new(logs)
	return logs
