# JsWeb3Node

`JsWeb3Node` is a base class that provides functionality for interacting with Web3 and Ethereum-based blockchains in Godot projects. It's designed to work in web environments and provides utility functions for working with JavaScript objects and promises.

## Properties

- `window`: JavaScript `window` object
- `provider`: Ethereum provider (BrowserProvider)
- `_ethers`: ethers.js library interface
- `console`: JavaScript console object
- `contract`: Smart contract instance
- `signer`: Ethereum signer object
- `Json`: Godot JSON utility object
- `logs`: Variable to store contract logs

## Methods

### _ready()

Initializes the Web3 environment when the node enters the scene tree.

### create_array(arr: Array) -> JavaScriptObject

Creates a JavaScript array from a Godot array.

### wait_till(promise, waittime=0.1)

Waits for a JavaScript promise to be fulfilled or rejected.

- `promise`: The JavaScript promise to wait for
- `waittime`: Time to wait between checks (default: 0.1 seconds)

### retrieve_logs(operation, waittime=0.1)

Retrieves logs from a contract operation.

- `operation`: The contract operation to execute
- `waittime`: Time to wait between checks (default: 0.1 seconds)

### JsLambda(jsstring)

Creates a JavaScript lambda function from a string.

### PromiseState(p)

Checks the state of a JavaScript promise.

### JsNew(new_obj, args)

Creates a new JavaScript object with the given arguments.

### _on_reject(args)

Default rejection handler for promises.

### new_obj()

Creates a new empty JavaScript object.

## Usage

To use `JsWeb3Node`, extend your custom classes from it:

```gdscript
extends JsWeb3Node
class_name MyCustomWeb3Class

func _ready():
    super._ready()
    # Your custom initialization code here
```

This base class provides essential functionality for interacting with Web3 and Ethereum in a Godot project, especially in web environments. It sets up the necessary JavaScript interfaces and provides utility functions for working with promises and JavaScript objects.
