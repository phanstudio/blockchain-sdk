extends Node

const PRICE_POOL_ADDRESS = '0xffacdbb2bf77efde0d26650213b1804ff89c824f';
const PRICE_POOL_ABI = [
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_minParticipants",
				"type": "uint256"
			},
			{
				"internalType": "uint8",
				"name": "_winnerCount",
				"type": "uint8"
			}
		],
		"name": "createPhase",
		"outputs": [],
		"stateMutability": "payable",
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
				"name": "participant",
				"type": "address"
			}
		],
		"name": "ParticipantRegistered",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_phaseId",
				"type": "uint256"
			},
			{
				"internalType": "address[]",
				"name": "_winners",
				"type": "address[]"
			}
		],
		"name": "payoutPhase",
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
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "phaseId",
				"type": "uint256"
			}
		],
		"name": "PhasePaid",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_phaseId",
				"type": "uint256"
			}
		],
		"name": "register",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_phaseId",
				"type": "uint256"
			},
			{
				"internalType": "uint8[]",
				"name": "_positions",
				"type": "uint8[]"
			},
			{
				"internalType": "uint256[]",
				"name": "_percentages",
				"type": "uint256[]"
			}
		],
		"name": "setPrizeDistribution",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_phaseId",
				"type": "uint256"
			}
		],
		"name": "getPhaseInfo",
		"outputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "totalPrize",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "minParticipants",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "registeredParticipants",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "isActive",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "isCompleted",
				"type": "bool"
			},
			{
				"internalType": "uint8",
				"name": "winnerCount",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "phaseParticipants",
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
				"name": "",
				"type": "uint256"
			}
		],
		"name": "phases",
		"outputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "totalPrize",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "minParticipants",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "registeredParticipants",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "isActive",
				"type": "bool"
			},
			{
				"internalType": "bool",
				"name": "isCompleted",
				"type": "bool"
			},
			{
				"internalType": "uint8",
				"name": "winnerCount",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]

const TEST_EVENT_ADDRESS = '0x65ee8bdf7cd4d3e124fc462d52e746db67f14c9c';
const TEST_EVENT_ABI = [
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
