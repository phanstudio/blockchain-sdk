# Wallet

`Wallet` is a class that extends `JsWeb3Node` and provides functionality for managing cryptocurrency wallet connections, network switching, and balance retrieval in a Godot project.

## Properties

- `wallet_address`: String representing the connected wallet address
- `is_wallet_connected`: Boolean indicating if a wallet is currently connected
- `is_connecting`: Boolean indicating if a connection attempt is in progress
- `accounts`: Array of connected account addresses

## Constants

- `SUPPORTED_CHAINS`: Dictionary of supported blockchain networks and their chain IDs

## Signals

- `wallet_connected(address: String)`: Emitted when a wallet is successfully connected
- `wallet_disconnected`: Emitted when the wallet is disconnected
- `wallet_error(error: String)`: Emitted when an error occurs during wallet operations
- `balance_updated(balance: String)`: Emitted when the wallet balance is updated

## Methods

### connect_wallet() -> void

Initiates the wallet connection process.

### reconnect() -> void

Attempts to reconnect to the wallet by requesting permissions and accounts.

### disconnect_wallet() -> void

Disconnects the current wallet and clears related data.

### switch_network(chain_name: String) -> void

Switches the connected wallet to a different blockchain network.

- `chain_name`: The name of the network to switch to (must be in `SUPPORTED_CHAINS`)

### get_balance() -> void

Retrieves the current balance of the connected wallet.

### set_accounts(response_array)

Sets the connected accounts based on the response from the wallet.

- `response_array`: Array of account addresses returned by the wallet

## Private Methods

### _on_reconnect(args)

Callback for successful wallet reconnection.

### _on_reconnect_error(args)

Callback for errors during wallet reconnection.

### _connect(args)

Callback for successful wallet connection.

### _on_confirm(args: Array) -> void

Handles confirmations for various wallet operations.

### _signer_initialized(args)

Callback for when the signer is initialized.

## Usage

To use the `Wallet` class in your Godot project:

1. Extend your custom class from `Wallet`:

   ```gdscript
   extends Wallet
   class_name MyWalletManager
   ```

2. Initialize the wallet connection:

   ```gdscript
   func _ready():
       connect_wallet()
   ```

3. Listen for wallet events:

   ```gdscript
   func _ready():
       connect("wallet_connected", self, "_on_wallet_connected")
       connect("balance_updated", self, "_on_balance_updated")

   func _on_wallet_connected(address):
       print("Wallet connected: ", address)

   func _on_balance_updated(balance):
       print("New balance: ", balance)
   ```

4. Perform wallet operations:

   ```gdscript
   func switch_to_ethereum():
       switch_network("ethereum")

   func check_balance():
       get_balance()
   ```

This `Wallet` class provides a comprehensive interface for managing wallet connections and interactions in a blockchain-based Godot project, particularly for web environments.
