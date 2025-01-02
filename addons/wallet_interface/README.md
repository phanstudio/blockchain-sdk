# Godot Web3 ABI Converter

A Godot Engine plugin that converts Ethereum smart contract ABIs into GDScript classes for seamless blockchain integration.

## Features
- Convert Ethereum ABI JSON files to GDScript contract classes
- Support for multiple contract imports
- Handles large numbers with custom BigNum implementation
- Editor integration with UI for easy conversion
- Batch processing support
- Automatic type conversion between Ethereum and GDScript types

## Installation

1. Create an `addons` directory in your Godot project if it doesn't exist
2. Clone or copy this repository into `addons/abi_importer`
3. Enable the plugin in Godot:
   - Go to Project → Project Settings → Plugins
   - Find "ABI Converter" and click the "Enable" checkbox

## Usage

### Using the Editor Plugin

1. Click the "ABI Converter" tab in the bottom panel of the editor
2. Click "Generate Contract from ABI"
3. Select one or more JSON files containing your contract ABIs
4. The converted GDScript files will be generated in the same directory as your JSON files

### JSON File Format
Your ABI JSON files should have the following structure:
```json
{
    "name": "MyContract",
    "address": "0x123...",
    "Abi": [
        // Standard Ethereum ABI array
    ]
}
```

### Generated Contract Usage
```gdscript
# After conversion, you can use your contract like this:
var my_contract = MyContractContract.new()

# Call a view function
var result = await my_contract.some_view_function("param1")

# Call a payable function
await my_contract.some_payable_function("param1", {"value": "1000000000000000000"})
```

## Type Mappings

### Input Types (Ethereum → GDScript)
- address → String
- string → String
- bytes32 → String
- uint256 → int
- uint8 → int
- address[] → Array
- uint256[] → Array

### Output Types (Ethereum → GDScript)
- address → String
- string → String
- bytes32 → String
- uint256 → BigNum
- uint8 → BigNum
- address[] → Array
- uint256[] → Array

## Working with Large Numbers

The converter includes a BigNum class for handling large numbers safely. Example usage:

```gdscript
# Creating BigNum instances
var num1 = BigNum.new("1000000000000000000")
var num2 = BigNum.new("2000000000000000000")

# Arithmetic operations
num1.add(num2)
num1.sub(num2)
num1.mult(num2)
num1.div(num2)

# Static operations
var sum = BigNum.plus(num1, num2)
var product = BigNum.multiply(num1, num2)
```

## Project Structure
```
addons/
  abi_importer/
    ├── plugin.gd           # Main plugin file
    ├── plugin.cfg          # Plugin configuration
    ├── abi_converter.gd    # ABI conversion logic
    ├── abi_importer.gd    # File handling and import logic
    └── bignum.gd          # Large number handling
```

## Requirements
- Godot 4.0 or higher
- Web3Global singleton with ContractManager
- JavaScript interface support for Web3 integration

## Limitations
- Only supports integer arithmetic (no floating point)
- Contract functions are asynchronous (use await)
- Generated files must be in project resource path

## Error Handling
- Invalid JSON files are reported with specific errors
- Generation errors are logged to the editor console
- Contract calls include built-in error checking

## Best Practices
1. Keep your ABI JSON files organized in a dedicated directory
2. Use clear, consistent naming for your contract files
3. Wait for contract operations to complete before calling new ones
4. Handle errors appropriately in your contract calls
5. Use BigNum for any large number operations

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

[Your License Here]

## Contact

[twitter](https://x.com/Phan73764817)
