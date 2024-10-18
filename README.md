# BlockchainSDK for Godot

The BlockchainSDK is a powerful toolkit for integrating blockchain functionality into your Godot projects. It provides a seamless interface for connecting wallets, managing accounts, interacting with smart contracts, and building decentralized applications (dApps) within the Godot game engine.

## Features

- Wallet connection and management
- Network switching (support for multiple blockchains)
- Balance retrieval and updates
- Smart contract interaction (query and execution)
- Event logging and parsing
- UI integration helpers
- Web3 utility functions

## Components

The SDK consists of several key components:

1. `JsWeb3Node`: Base class for Web3 functionality
2. `Wallet`: Manages wallet connections and account information
3. `ContractManager`: Handles smart contract interactions
4. `Web3Global`: Global access point for blockchain functionality

## Installation

1. Copy the BlockchainSDK files into your Godot project's `addons` folder.
2. Enable the plugin in Godot: Project > Project Settings > Plugins
3. Ensure you have the necessary dependencies installed (JavaScriptBridge)

## Usage

### Basic Setup

1. Create a global script (e.g., `Web3Global.gd`) to initialize the SDK:

```gdscript
extends Node

var wallet_manager: Wallet
var contract_manager: ContractManager

func _ready():
    wallet_manager = Wallet.new()
    contract_manager = ContractManager.new()
    add_child(wallet_manager)
    add_child(contract_manager)
```

2. In your main scene or UI script, access the SDK components:

```gdscript
extends Control

var wallet
var contract_manager

func _ready():
    wallet = Web3Global.wallet_manager
    contract_manager = Web3Global.contract_manager
```

### Wallet Management

Connect to a wallet:

```gdscript
func connect_wallet():
    wallet.connect_wallet()

func _on_wallet_connected(address: String):
    print("Connected to wallet: ", address)

func _on_balance_updated(balance: String):
    print("New balance: ", balance)

# In _ready():
wallet.connect("wallet_connected", self, "_on_wallet_connected")
wallet.connect("balance_updated", self, "_on_balance_updated")
```

### Smart Contract Interaction

Initialize and interact with a smart contract:

```gdscript
func init_contract():
    var address = "0x1234567890123456789012345678901234567890"
    var abi = [...] # Your contract ABI here
    contract_manager.smartcontract(address, abi)

func query_contract():
    contract_manager.contract.myReadFunction().then(contract_manager.query_contract)

func execute_contract():
    contract_manager.contract.myWriteFunction().then(contract_manager.execute_contract)

# In _ready():
contract_manager.connect("contract_query_result", self, "_on_query_result")
contract_manager.connect("contract_execution_result", self, "_on_execution_result")
```

### UI Integration

Create a simple wallet UI:

```gdscript
extends MarginContainer

@onready var connect_button = $ConnectButton
@onready var address_label = $AddressLabel
@onready var balance_label = $BalanceLabel

func _ready():
    wallet.connect("wallet_connected", self, "_on_wallet_connected")
    wallet.connect("wallet_disconnected", self, "_on_wallet_disconnected")
    wallet.connect("balance_updated", self, "_update_balance")
    connect_button.connect("pressed", self, "_on_connect_pressed")

func _on_connect_pressed():
    if wallet.is_wallet_connected:
        wallet.disconnect_wallet()
    else:
        wallet.connect_wallet()

func _on_wallet_connected(address):
    address_label.text = "Address: " + address
    connect_button.text = "Disconnect"

func _on_wallet_disconnected():
    address_label.text = "Address: Not Connected"
    balance_label.text = "Balance: --"
    connect_button.text = "Connect Wallet"

func _update_balance(balance):
    balance_label.text = "Balance: " + balance
```

## Advanced Usage

### Network Switching

Switch between different blockchain networks:

```gdscript
wallet.switch_network("ethereum") # or "polygon", "Sei", etc.
```

### Custom Contract Events

Listen for and parse custom contract events:

```gdscript
func _on_contract_event(event):
    var decoded_event = contract_manager.createAbiFromFragment(event)
    print("Event received: ", decoded_event)

# In _ready():
contract_manager.connect("contract_event", self, "_on_contract_event")
```

## Best Practices

1. Always check if the web environment is available before using Web3 features.
2. Handle potential errors and provide user feedback.
3. Use asynchronous operations (e.g., `wait_till()`) for blockchain interactions to prevent freezing the UI.
4. Implement proper security measures, especially when handling private keys or sensitive data.

## Troubleshooting

- If you encounter "Already processing eth_requestAccounts" errors, implement a debounce mechanism or error handling to prevent multiple simultaneous connection attempts.
- Ensure your contract ABI is correct and up-to-date when interacting with smart contracts.
- For network-specific issues, verify that you're connected to the correct network and that your wallet supports it.

## Contributing

Contributions to the BlockchainSDK are welcome! Please submit issues and pull requests on our GitHub repository.

## License



## Support

For questions, issues, or feature requests, please open an issue on the GitHub repository or contact our support team at [your support email/channel].

---
