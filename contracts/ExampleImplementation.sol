//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "./ERC7578.sol";

/**
 * @title Example Implementation Contract
 * @author DESAT
 * @notice Example Contract for using Physical Asset Redemption Standard
 **/
contract ExampleImplementation is ERC7578 {
    uint256 private _nextTokenId;

    /**
     * @notice Constructor for the ExampleImplementation contract
     * @param name The name of the token
     * @param symbol The symbol of the token
     */
    constructor(string memory name, string memory symbol) ERC7578(name, symbol) {
        _nextTokenId = 1;
    }

    /**
     * @notice Public mint function
     * @param to The address to mint the token to
     * @param tokenId The token ID of the initialized token
     */
    function mintToken(address to, Properties calldata properties) public returns (uint256 tokenId) {
        // Get the next `tokenId` by initializing the ERC-7578 properties
        tokenId = _initializeProperties(properties);

        // Interactions: mint the `tokenId` token to the `to` address
        _safeMint(to, tokenId);
    }

    /**
     * @notice Public burn function
     * @param tokenId The token ID of the minted token
     */
    function burnToken(uint256 tokenId) public {
        _burn(tokenId);
    }

    /** @notice Initializes the ERC-7578 properties of the next token to be minted
     *
     * Notes:
     * - The ERC-7578 properties MUST be initialized before minting the token
     *
     * @param properties The ERC-7578 properties of the token
     * @return tokenId The next ID of the token to be minted
     */
    function _initializeProperties(Properties calldata properties) internal returns (uint256 tokenId) {
        // Get the next token ID
        tokenId = _nextTokenId;

        // Effects: set the ERC-7578 properties of the `tokenId` token
        setProperties(tokenId, properties);

        // Increment using the unchecked mode since `_nextTokenId` will never overflow in a realistic scenario
        unchecked {
            ++_nextTokenId;
        }

        return tokenId;
    }
}
