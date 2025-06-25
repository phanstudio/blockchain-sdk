# BlockchainSDK for Godot

The **BlockchainSDK** is a powerful toolkit for integrating blockchain functionality into your Godot projects. It provides a seamless interface for connecting wallets, managing accounts, interacting with smart contracts, and building decentralized applications (dApps) within the Godot game engine.

## Features

* Wallet connection and management
* Network switching (supports multiple blockchains)
* Balance retrieval and real-time updates
* Smart contract interaction (query and execution)
* Event logging and parsing
* UI integration helpers
* Web3 utility functions

## Components

The SDK consists of several key components:

1. `JsWeb3Node`: Base class for Web3 functionality
2. `Wallet`: Manages wallet connections and account information
3. `ContractManager`: Handles smart contract interactions
4. `Web3Global`: Global access point for blockchain operations
5. `ContractBase`: Abstract base class for contracts
6. `Sequence3`: Manages promises and contract calls (alongside traditional `await` methods)

## Usage Examples

### Creating a Contract Instance

```gdscript
var contract = TemplateErc721Contract.new("0x7D4B7B8CA7E1a24928Bb96D59249c7a5bd1DfBe6")
```

### Converting JSON ABI to Native GDScript

```gdscript
var contract = SimpleNftContract.new("0xbB700D8Ce0D97f9600E5c5f3EF37ec01147Db4b9")
var cm = contract.isApprovedForAll.bind(WalletGlobal.wallet_address, "0x7D4B7B8CA7E1a24928Bb96D59249c7a5bd1DfBe6", true)
```

### Simple Getters with Sequence3

```gdscript
var contract = SimpleSpellCardNftContract.new()
var sequence = Sequence3.new()
sequence.run_async(contract.name.bind(true))
sequence.then_sync(func(args): print(args))
sequence.then_async(func(_args): return contract.owner.bind())
sequence.then_sync(func(args): print(args))
```

### Old Method for Setters

```gdscript
var contract = TemplateErc721Contract.new("0x7D4B7B8CA7E1a24928Bb96D59249c7a5bd1DfBe6")
await contract.bulkSafeMint(WalletGlobal.wallet_address, ["non", "non", "non"])
```

### Old Method for Getters

```gdscript
var contract = TemplateErc721Contract.new("0xF1ddcE4A958E4FBaa4a14cB65073a28663F2F350")
await contract.name(true)
```

### Setters with Sequence

```gdscript
var sequence = Sequence3.new()
sequence.run_async(contract.setApprovalForAll.bind(contract1.contract_address, true))
sequence.run_async(contract1.setMinimumBurnAmount.bind(2))
sequence.then_async(func(_args): return contract1.createPremium.bind([4,5], 6, {"value": Web3Global.contract_manager.parseUnit(0.5)}))
```

### Using Value Parameter

```gdscript
var contract = TemplateBurnNftContract.new()
var contract1 = BurnManagerContract.new()
var sequence = Sequence3.new()
sequence.run_async(contract1.getBurnFee.bind(true))
sequence.then_async(func(burnfee): return contract1.createPremium.bind([10,11], 12, {"value": burnfee.value}))
```

## 🚀 Sponsors

This project is proudly supported by:

* **[Sei](https://sei.io)** via [Karma GAP](https://gap.karmahq.xyz/community/sei) — Special thanks for their support and commitment to open-source innovation.

## Support

For questions, issues, or feature requests, please open an issue on the GitHub repository or contact our support team at [twitter](https://x.com/devphan_).
