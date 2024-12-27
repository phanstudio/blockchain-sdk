extends Node
class_name DragonSwapRouterContract
var contract: JavaScriptObject
var contract_manager: ContractManager = Web3Global.contract_manager
func _init() -> void:
	var address = '0x2346d3a6fb18ff3ae590ea31d9e41e6ab8c9f5eb'
	var abi = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_factory",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_WSEI",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "WSEI",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
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
				"name": "tokenA",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "tokenB",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amountADesired",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountBDesired",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountAMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountBMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "addLiquidity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountA",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountB",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "token",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amountTokenDesired",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountTokenMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEIMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "addLiquiditySEI",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountToken",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEI",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "factory",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "reserveIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "reserveOut",
				"type": "uint256"
			}
		],
		"name": "getAmountIn",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountIn",
				"type": "uint256"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "reserveIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "reserveOut",
				"type": "uint256"
			}
		],
		"name": "getAmountOut",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			}
		],
		"name": "getAmountsIn",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountIn",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			}
		],
		"name": "getAmountsOut",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountA",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "reserveA",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "reserveB",
				"type": "uint256"
			}
		],
		"name": "quote",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountB",
				"type": "uint256"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "tokenA",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "tokenB",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountAMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountBMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "removeLiquidity",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountA",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountB",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "token",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountTokenMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEIMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "removeLiquiditySEI",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountToken",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEI",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "token",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountTokenMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEIMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "removeLiquiditySEISupportingFeeOnTransferTokens",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountSEI",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "token",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountTokenMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEIMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "approveMax",
				"type": "bool"
			},
			{
				"internalType": "uint8",
				"name": "v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "s",
				"type": "bytes32"
			}
		],
		"name": "removeLiquiditySEIWithPermit",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountToken",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEI",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "token",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountTokenMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountSEIMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "approveMax",
				"type": "bool"
			},
			{
				"internalType": "uint8",
				"name": "v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "s",
				"type": "bytes32"
			}
		],
		"name": "removeLiquiditySEIWithPermitSupportingFeeOnTransferTokens",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountSEI",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "tokenA",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "tokenB",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "liquidity",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountAMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountBMin",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "approveMax",
				"type": "bool"
			},
			{
				"internalType": "uint8",
				"name": "v",
				"type": "uint8"
			},
			{
				"internalType": "bytes32",
				"name": "r",
				"type": "bytes32"
			},
			{
				"internalType": "bytes32",
				"name": "s",
				"type": "bytes32"
			}
		],
		"name": "removeLiquidityWithPermit",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "amountA",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountB",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountOutMin",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapExactSEIForTokens",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountOutMin",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapExactSEIForTokensSupportingFeeOnTransferTokens",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountOutMin",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapExactTokensForSEI",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountOutMin",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapExactTokensForSEISupportingFeeOnTransferTokens",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountOutMin",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapExactTokensForTokens",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountIn",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountOutMin",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapExactTokensForTokensSupportingFeeOnTransferTokens",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapSEIForExactTokens",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountInMax",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapTokensForExactSEI",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "amountOut",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "amountInMax",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "path",
				"type": "address[]"
			},
			{
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "deadline",
				"type": "uint256"
			}
		],
		"name": "swapTokensForExactTokens",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "amounts",
				"type": "uint256[]"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"stateMutability": "payable",
		"type": "receive"
	}
	]
	contract = contract_manager.smartcontract(address, abi)

func WSEI() -> String:
	var logs = await contract_manager.runsafely(
		contract.WSEI,
		[],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling WSEI, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs

func addLiquidity(tokenA: String, tokenB: String, amountADesired: int, amountBDesired: int, amountAMin: int, amountBMin: int, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.addLiquidity,
		[tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling addLiquidity, %s" % 
		[contract_manager.output_logs["error"]]
	);

func addLiquiditySEI(token: String, amountTokenDesired: int, amountTokenMin: int, amountSEIMin: int, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.addLiquiditySEI,
		[token, amountTokenDesired, amountTokenMin, amountSEIMin, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling addLiquiditySEI, %s" % 
		[contract_manager.output_logs["error"]]
	);

func factory() -> String:
	var logs = await contract_manager.runsafely(
		contract.factory,
		[],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling factory, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs

func getAmountIn(amountOut: int, reserveIn: int, reserveOut: int) -> BigNum:
	var logs = await contract_manager.runsafely(
		contract.getAmountIn,
		[amountOut, reserveIn, reserveOut],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getAmountIn, %s" % 
		[contract_manager.output_logs["error"]]
	);
	logs = BigNum.new(logs)
	return logs

func getAmountOut(amountIn: int, reserveIn: int, reserveOut: int) -> BigNum:
	var logs = await contract_manager.runsafely(
		contract.getAmountOut,
		[amountIn, reserveIn, reserveOut],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getAmountOut, %s" % 
		[contract_manager.output_logs["error"]]
	);
	logs = BigNum.new(logs)
	return logs

func getAmountsIn(amountOut: int, path: Array) -> Array:
	var logs = await contract_manager.runsafely(
		contract.getAmountsIn,
		[amountOut, path],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getAmountsIn, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs

func getAmountsOut(amountIn: int, path: Array) -> Array:
	var logs = await contract_manager.runsafely(
		contract.getAmountsOut,
		[amountIn, path],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling getAmountsOut, %s" % 
		[contract_manager.output_logs["error"]]
	);
	return logs

func quote(amountA: int, reserveA: int, reserveB: int) -> BigNum:
	var logs = await contract_manager.runsafely(
		contract.quote,
		[amountA, reserveA, reserveB],
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling quote, %s" % 
		[contract_manager.output_logs["error"]]
	);
	logs = BigNum.new(logs)
	return logs

func removeLiquidity(tokenA: String, tokenB: String, liquidity: int, amountAMin: int, amountBMin: int, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.removeLiquidity,
		[tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling removeLiquidity, %s" % 
		[contract_manager.output_logs["error"]]
	);

func removeLiquiditySEI(token: String, liquidity: int, amountTokenMin: int, amountSEIMin: int, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.removeLiquiditySEI,
		[token, liquidity, amountTokenMin, amountSEIMin, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling removeLiquiditySEI, %s" % 
		[contract_manager.output_logs["error"]]
	);

func removeLiquiditySEISupportingFeeOnTransferTokens(token: String, liquidity: int, amountTokenMin: int, amountSEIMin: int, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.removeLiquiditySEISupportingFeeOnTransferTokens,
		[token, liquidity, amountTokenMin, amountSEIMin, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling removeLiquiditySEISupportingFeeOnTransferTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func removeLiquiditySEIWithPermit(token: String, liquidity: int, amountTokenMin: int, amountSEIMin: int, to: String, deadline: int, approveMax: Variant, v: int, r: String, s: String, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.removeLiquiditySEIWithPermit,
		[token, liquidity, amountTokenMin, amountSEIMin, to, deadline, approveMax, v, r, s, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling removeLiquiditySEIWithPermit, %s" % 
		[contract_manager.output_logs["error"]]
	);

func removeLiquiditySEIWithPermitSupportingFeeOnTransferTokens(token: String, liquidity: int, amountTokenMin: int, amountSEIMin: int, to: String, deadline: int, approveMax: Variant, v: int, r: String, s: String, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.removeLiquiditySEIWithPermitSupportingFeeOnTransferTokens,
		[token, liquidity, amountTokenMin, amountSEIMin, to, deadline, approveMax, v, r, s, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling removeLiquiditySEIWithPermitSupportingFeeOnTransferTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func removeLiquidityWithPermit(tokenA: String, tokenB: String, liquidity: int, amountAMin: int, amountBMin: int, to: String, deadline: int, approveMax: Variant, v: int, r: String, s: String, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.removeLiquidityWithPermit,
		[tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline, approveMax, v, r, s, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling removeLiquidityWithPermit, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapExactSEIForTokens(amountOutMin: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapExactSEIForTokens,
		[amountOutMin, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapExactSEIForTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapExactSEIForTokensSupportingFeeOnTransferTokens(amountOutMin: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapExactSEIForTokensSupportingFeeOnTransferTokens,
		[amountOutMin, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapExactSEIForTokensSupportingFeeOnTransferTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapExactTokensForSEI(amountIn: int, amountOutMin: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapExactTokensForSEI,
		[amountIn, amountOutMin, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapExactTokensForSEI, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapExactTokensForSEISupportingFeeOnTransferTokens(amountIn: int, amountOutMin: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapExactTokensForSEISupportingFeeOnTransferTokens,
		[amountIn, amountOutMin, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapExactTokensForSEISupportingFeeOnTransferTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapExactTokensForTokens(amountIn: int, amountOutMin: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapExactTokensForTokens,
		[amountIn, amountOutMin, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapExactTokensForTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapExactTokensForTokensSupportingFeeOnTransferTokens(amountIn: int, amountOutMin: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapExactTokensForTokensSupportingFeeOnTransferTokens,
		[amountIn, amountOutMin, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapExactTokensForTokensSupportingFeeOnTransferTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapSEIForExactTokens(amountOut: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapSEIForExactTokens,
		[amountOut, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapSEIForExactTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapTokensForExactSEI(amountOut: int, amountInMax: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapTokensForExactSEI,
		[amountOut, amountInMax, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapTokensForExactSEI, %s" % 
		[contract_manager.output_logs["error"]]
	);

func swapTokensForExactTokens(amountOut: int, amountInMax: int, path: Array, to: String, deadline: int, value: Dictionary) -> void:
	var logs = await contract_manager.runsafely(
		contract.swapTokensForExactTokens,
		[amountOut, amountInMax, path, to, deadline, value],
		"execute"
	)
	assert(
		str(logs) != contract_manager.ERROR and logs != null, 
		"ERROR: An error occured while calling swapTokensForExactTokens, %s" % 
		[contract_manager.output_logs["error"]]
	);
