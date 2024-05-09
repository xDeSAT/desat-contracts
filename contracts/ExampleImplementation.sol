//SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.21;

import "./PhysicalAssetRedemption.sol";

/**
 * @title Example Implementation Contract
 * @author DeSAT
 * @notice Example Contract for using Physical Asset Redemption Standard
 **/
contract ExampleImplementation is PhysicalAssetRedemption {
    uint256 private _tokenId;

    /**
     * @notice Constructor for the ExampleImplementation contract
     * @param name The name of the token
     * @param symbol The symbol of the token
     */
    constructor(string memory name, string memory symbol) PhysicalAssetRedemption(name, symbol) {
        // counter should start from 1
        _tokenId = 1;
    }

    /**
     * @notice Properties require initialization before minting a token
     * @param properties The properties of the token
     */
    function initializeProperties(Properties calldata properties) public {
        setProperties({ tokenId: _tokenId, properties: properties });

        unchecked {
            ++_tokenId;
        }
    }

    /**
     * @notice Public mint function. Requires tokenId from initializePropeties
     * @param to The address to mint the token to
     * @param tokenId The token id of the initilized token
     */
    function mintToken(uint256 tokenId, address to) public {
        _safeMint(to, tokenId);
    }

    /**
     * @notice Public burn function. Requires tokenId from initializePropeties
     * @param tokenId The token id of the minted token
     */
    function burnToken(uint256 tokenId) public {
        _burn(tokenId);
    }
}
