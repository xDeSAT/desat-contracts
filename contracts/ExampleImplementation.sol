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
     * @param tokenIssuer The network or entity minting the tokens
     * @param assetHolder The legal owner of the physical asset
     * @param storedLocation The physical storage location
     * @param terms Link to IPFS contract, agreement or terms
     * @param jurisdiction The legal justification set out in the terms
     * @param declaredValueCurrency The declared value currency at time of token miniting
     * @param declaredValueAmount The declared value amount at time of token miniting
     */
    function initializeProperties(
        string memory tokenIssuer,
        string memory assetHolder,
        string memory storedLocation,
        string memory terms,
        string memory jurisdiction,
        string memory declaredValueCurrency,
        uint256 declaredValueAmount
    ) public {
        setProperties(
            _tokenId,
            tokenIssuer,
            assetHolder,
            storedLocation,
            terms,
            jurisdiction,
            declaredValueCurrency,
            declaredValueAmount
        );

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
