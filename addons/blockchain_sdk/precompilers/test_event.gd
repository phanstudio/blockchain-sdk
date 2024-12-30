extends Node
class_name TestEventContract
var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager
func _init() -> void:
	var address = '0x65ee8bdf7cd4d3e124fc462d52e746db67f14c9c'
	var abi = [
	{
		"inputs": [],
		"name": "createPhase",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "phaseId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "totalPrize",
				"type": "uint256"
			}
		],
		"name": "PhaseCreated",
		"type": "event"
	}
	]
	contract = contract_manager.smartcontract(address, abi)

func createPhase(value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.createPhase,
		[value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling createPhase, %s" % 
		[contract_manager.output_logs["error"]]
	);
