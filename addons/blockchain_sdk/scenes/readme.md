# BlockchainSDK for Godot

The BlockchainSDK is a powerful tool for integrating blockchain functionality into your Godot projects. It provides an easy-to-use interface for connecting wallets, managing accounts, and interacting with smart contracts.

## Features

- Wallet connection and disconnection
- Balance retrieval
- Address display
- UI updates based on wallet connection status

## Installation

1. Copy the BlockchainSDK files into your Godot project.
2. Ensure you have the necessary dependencies installed (Web3Global, JavaScriptBridge).

## Usage

### Basic Setup

1. Extend your script from `MarginContainer` or any suitable Node:

```gdscript
@tool
extends MarginContainer
```

2. Set up references to your UI elements and the wallet manager:

```gdscript
@onready var connectbutton = %ConnectButton
@onready var AmountLabel = %AmountLabel
@onready var AddressLabel = %AddressLabel
@onready var wallet = Web3Global.wallet_manager
```

### Connecting Signals

In your `_ready()` function, connect the necessary signals:

```gdscript
func _ready():
    if OS.has_feature("web"):
        wallet.connect("wallet_connected", _on_wallet_connected)
        wallet.connect("wallet_disconnected", _on_wallet_disconnected)
        wallet.connect("balance_updated", _update_balance)
    connectbutton.connect("pressed", connect_wallet)
    _update_wallet_ui(false)
```

### Wallet Connection

Implement the `connect_wallet()` function to handle wallet connection/disconnection:

```gdscript
func connect_wallet() -> void:
    if wallet.is_wallet_connected:
        wallet.disconnect_wallet()
    else:
        wallet.connect_wallet()
```

### Updating UI

Create functions to update the UI based on wallet status:

```gdscript
func _on_wallet_connected(address: String) -> void:
    _update_wallet_ui(true)

func _on_wallet_disconnected() -> void:
    _update_wallet_ui(false)

func _update_balance(balance: String) -> void:
    amounttext = "Balance: " + balance + " SEI"

func _update_wallet_ui(connected: bool) -> void:
    if connected:
        connecttext = "Disconnect Wallet"
        addresstext = "Address: " + wallet.wallet_address
    else:
        connecttext = "Connect Wallet"
        addresstext = "Address: "
    AddressLabel.visible = connected
    AmountLabel.visible = connected
```

### Exporting Variables

Use `@export` variables to easily modify text in the Godot editor:

```gdscript
@export var addresstext := "":
    set(new_text):
        set_text(AddressLabel, new_text)
        addresstext = new_text
    get: 
        return get_text(AddressLabel)

@export var amounttext := "":
    set(new_text):
        set_text(AmountLabel, new_text)
        amounttext = new_text
    get: 
        return get_text(AmountLabel)

@export var connecttext := "":
    set(new_text):
        set_text(connectbutton, new_text)
        connecttext = new_text
    get: 
        return get_text(connectbutton)
```

## Important Notes

- This SDK is designed for web-based projects. Ensure you're running in a web environment.
- Handle potential errors, such as the "Already processing eth_requestAccounts" error, by implementing appropriate error handling and user feedback mechanisms.

## Contributing

Contributions to the BlockchainSDK are welcome. Please submit issues and pull requests on our GitHub repository.


