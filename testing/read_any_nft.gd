extends Node
class_name ReadAnyNftContract
var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager
func _init(address: String) -> void:
	var abi = [
	{
		"inputs": [
			{
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "tokenURI",
		"outputs": [
			{
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			}
		],
		"name": "balanceOf",
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
				"name": "tokenId",
				"type": "uint256"
			}
		],
		"name": "ownerOf",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
	]
	contract = contract_manager.smartcontract(address, abi)

func tokenURI(tokenId: int) -> String:
	var logs = await contract_manager.runsafely(
		contract.tokenURI,
		[tokenId],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling tokenURI, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs

func balanceOf(owner: String) -> BigNum:
	var logs = await contract_manager.runsafely(
		contract.balanceOf,
		[owner],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling balanceOf, %s" % 
		[contract_manager.output_logs["error"]]
	);
	logs = BigNum.new(logs)
	return logs

func ownerOf(tokenId: int) -> String:
	var logs = await contract_manager.runsafely(
		contract.ownerOf,
		[tokenId],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling ownerOf, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs
