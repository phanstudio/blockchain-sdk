extends Node
class_name PrecompliedAddressContract

var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager

func _init() -> void:
	var address = '0x0000000000000000000000000000000000001004'
	var abi = [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "addr",
				"type": "string"
			}
		],
		"name": "getEvmAddr",
		"outputs": [
			{
				"internalType": "address",
				"name": "response",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "addr",
				"type": "address"
			}
		],
		"name": "getSeiAddr",
		"outputs": [
			{
				"internalType": "string",
				"name": "response",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "v",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "r",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "s",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "customMessage",
				"type": "string"
			}
		],
		"name": "associate",
		"outputs": [
			{
				"internalType": "string",
				"name": "seiAddr",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "evmAddr",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "pubKeyHex",
				"type": "string"
			}
		],
		"name": "associatePubKey",
		"outputs": [
			{
				"internalType": "string",
				"name": "seiAddr",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "evmAddr",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
	]
	contract = contract_manager.smartcontract(address, abi)

func getEvmAddr(addr: int) -> String:
	var logs = await contract_manager.runsafely(
		contract.getEvmAddr,
		[addr]
	)
	if logs != contract_manager.ERROR: return logs
	assert( false, "ERROR: An error occured while calling getEvmAddr");
	return ""

func getSeiAddr(addr: String) -> String:
	var logs = await contract_manager.runsafely(
		contract.getSeiAddr,
		[addr]
	)
	if logs != contract_manager.ERROR: return logs
	assert( false, "ERROR: An error occured while calling getSeiAddr");
	return ""

func associate(v: int, r: int, s: int, customMessage: int) -> Array:
	var logs = await contract_manager.runsafely(
		contract.associate,
		[v, r, s, customMessage]
	)
	if logs != contract_manager.ERROR: return logs
	assert( false, "ERROR: An error occured while calling associate");
	return []

func associatePubKey(pubKeyHex: int) -> Array:
	var logs = await contract_manager.runsafely(
		contract.associatePubKey,
		[pubKeyHex]
	)
	if logs != contract_manager.ERROR: return logs
	assert( false, "ERROR: An error occured while calling associatePubKey");
	return []
