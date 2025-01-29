extends Node
class_name PrecompliedAddressContract

var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager

func _init(address: String = "") -> void:
	if not address: # for custom abi support
		address = '0x0000000000000000000000000000000000001004'
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

func getEvmAddr(addr: String, fast: bool= false) -> String:
	var logs = await contract_manager.querysafely(
		contract.getEvmAddr,
		[addr],
		fast
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getEvmAddr, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs

func getSeiAddr(addr: String, fast: bool= false) -> String:
	var logs = await contract_manager.querysafely(
		contract.getSeiAddr,
		[addr],
		fast
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getSeiAddr, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs

func associate(v: String, r: String, s: String, customMessage: String) -> void:
	var logs = await contract_manager.runsafely(
		contract.associate,
		[v, r, s, customMessage],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling associate, %s" % 
		[contract_manager.output_logs["error"]]
	);

func associatePubKey(pubKeyHex: String) -> void:
	var logs = await contract_manager.runsafely(
		contract.associatePubKey,
		[pubKeyHex],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling associatePubKey, %s" % 
		[contract_manager.output_logs["error"]]
	);
