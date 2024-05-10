//SPDX-License-Identifier: UNLICENSED
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
        _tokenId = 1;
    }

    /**
     * @notice Initializes the properties of the next token
     * @dev Properties require to be initialized before minting a token
     * @param properties The properties of the token
     */
    function initializeProperties(Properties calldata properties) public {
        setProperties({ tokenId: _tokenId, properties: properties });

        unchecked {
            ++_tokenId;
        }
    }

    /**
     * @notice Public mint function
     * @param to The address to mint the token to
     * @param tokenId The token ID of the initialized token
     */
    function mintToken(uint256 tokenId, address to) public {
        _safeMint(to, tokenId);
    }

    /**
     * @notice Public burn function
     * @param tokenId The token ID of the minted token
     */
    function burnToken(uint256 tokenId) public {
        _burn(tokenId);
    }
}
