# DESAT Contracts

**A library with ERC implementations used across the DESAT protocol smart contracts**

- Implementation of [ERC7578](https://eips.ethereum.org/EIPS/eip-7578) standard

## Installation

**Foundry**

```bash
forge install xDeSAT/desat-contracts
```

Then add the following line in the `remappings.txt` file:
`@xDeSAT/desat-contracts/=lib/xDeSAT/desat-contracts/contracts/`

**Hardhat**

```bash
npm install @xdesat/desat-contracts
```

## Usage

Once installed, you can use the ERC7578 standard by importing it in your `.sol` contract:

```
pragma solidity ^0.8.21;

import {ERC7578} from "@xdesat/desat-contracts/contracts/ERC7578.sol";

contract MyContract is ERC7578 {
    constructor(string memory name, string memory symbol) ERC7578(name, symbol) {
    }
}
```
