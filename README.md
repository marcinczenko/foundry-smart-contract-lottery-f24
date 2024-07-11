# foundry-smart-contract-lottery-f24

This is the repo from following the online training [Foundry Smart Contract Lottery](https://github.com/Cyfrin/foundry-full-course-cu?tab=readme-ov-file#section-9-foundry-smart-contract-lottery).

It builds on top of [foundry-fund-me-f24](https://github.com/marcinczenko/foundry-fund-me-f24) and introduces further more advanced topic related to randomness and "upkeeps" allowing the off-chain automation to call our own contracts automatically.

## Foundry (original generated content)

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
