//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { ERC7578, Properties } from "./ERC7578.sol";

/**
 * @notice Example implementation of the ERC-7578 Physical Asset Redemption Standard
 **/
contract ExampleImplementation is ERC7578 {
    uint256 private _nextTokenId;

    /**
     * @notice Initializes the name and symbol of the ERC-721 collection and sets the next token ID to start at 1
     * @param name The name of the collection
     * @param symbol The symbol of the collection
     */
    constructor(string memory name, string memory symbol) ERC7578(name, symbol) {
        _nextTokenId = 1;
    }

    /**
     * @notice Mints a new token to the `to` address for a physical asset with the `properties` properties
     * @param to The address to mint the token to
     * @param properties The properties of the token
     * @return tokenId The unique identifier of the token
     */
    function mint(address to, Properties calldata properties) public returns (uint256 tokenId) {
        // Get the next `tokenId` by initializing the ERC-7578 properties
        tokenId = _initializeProperties(properties);

        // Interactions: mint the `tokenId` token to the `to` address
        _safeMint(to, tokenId);
    }

    /**
     * @notice Burns the `tokenId` token
     * @param tokenId The token ID of the minted token
     */
    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    /** @notice Initializes the ERC-7578 properties of the next token to be minted
     *
     * Notes:
     * - The ERC-7578 properties MUST be initialized before minting the token
     *
     * @param properties The ERC-7578 properties of the token
     * @return tokenId The unique identifier of the token
     */
    function _initializeProperties(Properties calldata properties) internal returns (uint256 tokenId) {
        // Get the next token ID
        tokenId = _nextTokenId;

        // Effects: set the ERC-7578 properties of the `tokenId` token
        _setPropertiesOf(tokenId, properties);

        // Increment using the unchecked mode since `_nextTokenId` will never overflow in a realistic scenario
        unchecked {
            ++_nextTokenId;
        }

        return tokenId;
    }
}
