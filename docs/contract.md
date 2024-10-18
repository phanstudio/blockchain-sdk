# ContractManager

`ContractManager` is a class that extends `JsWeb3Node` and provides functionality for interacting with smart contracts on Ethereum-compatible blockchains in a Godot project.

## Signals

- `contract_created(address: String)`: Emitted when a new contract is created
- `contract_query_result(result)`: Emitted when a contract query (read operation) is completed
- `contract_execution_result(result)`: Emitted when a contract execution (write operation) is completed

## Methods

### smartcontract(contract_address, contract_abi)

Creates a new contract instance.

- `contract_address`: The address of the deployed contract
- `contract_abi`: The ABI (Application Binary Interface) of the contract

### createAbiFromFragment(fragment)

Creates an ABI string from a contract event fragment.

- `fragment`: The event fragment object

### sign_pressed()

Initiates a message signing process (work in progress).

## Private Methods

### _query_contract(args)

Handles the response from a contract query (read operation).

### _execute_contract(args)

Handles the response from a contract execution (write operation).

### _wait(args)

Handles the response after waiting for a transaction to be mined.

### _sign_returned(p)

Callback for successful message signing.

### _sign_error(p)

Callback for errors during message signing.

## Usage

To use the `ContractManager` class in your Godot project:

1. Extend your custom class from `ContractManager`:

   ```gdscript
   extends ContractManager
   class_name MyContractManager
   ```

2. Initialize a contract:

   ```gdscript
   func init_contract():
       var address = "0x1234567890123456789012345678901234567890"
       var abi = [
           {
               "inputs": [],
               "name": "myFunction",
               "outputs": [{"type": "uint256"}],
               "stateMutability": "view",
               "type": "function"
           }
       ]
       smartcontract(address, abi)
   ```

3. Query the contract:

   ```gdscript
   func query_my_function():
       contract.myFunction().then(query_contract)
   ```

4. Execute a contract function:

   ```gdscript
   func execute_my_function():
       contract.myFunction().then(execute_contract)
   ```

5. Listen for contract events:

   ```gdscript
   func _ready():
       connect("contract_query_result", self, "_on_query_result")
       connect("contract_execution_result", self, "_on_execution_result")

   func _on_query_result(result):
       print("Query result: ", result)

   func _on_execution_result(result):
       print("Execution result: ", result)
   ```

This `ContractManager` class provides a comprehensive interface for interacting with smart contracts in a blockchain-based Godot project, particularly for web environments. It handles contract initialization, querying, execution, and event logging.
