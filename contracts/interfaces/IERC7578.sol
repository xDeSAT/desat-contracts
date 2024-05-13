//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

/**
 * @notice Struct encapsulating fields required to by the ERC-7578 standard to represent the physical asset
 * @param tokenIssuer The network or entity minting the token
 * @param assetHolder The legal owner of the physical asset
 * @param storedLocation The physical storage location
 * @param terms Link to IPFS contract, agreement or terms
 * @param jurisdiction The legal justification set out in the terms
 * @param declaredValue The declared value at time of token minting
 */
struct Properties {
    string tokenIssuer;
    string assetHolder;
    string storedLocation;
    string terms;
    string jurisdiction;
    Amount declaredValue;
}

/**
 * @notice Struct encapsulating fields describing the declared value of the physical asset
 * @param currency The currency of the amount
 * @param value The value of the amount
 */
struct Amount {
    string currency;
    uint256 value;
}

/**
 * @notice Required interface of an ERC-7578 compliant contract
 */
interface IERC7578 {
    /**
     * @notice Emitted when the properties of the `tokenId` token are set
     *
     * @param tokenId The ID of the token
     * @param properties The properties of the token
     */
    event PropertiesSet(uint256 indexed tokenId, Properties properties);

    /**
     * @notice Emitted when the properties of the `tokenId` token are removed
     *
     * @param tokenId The ID of the token
     * @param properties The properties of the token
     */
    event PropertiesRemoved(uint256 indexed tokenId, Properties properties);

    /**
     * @notice Retrieves all the properties of the `tokenId` token
     * @dev Does NOT revert if token doesn't exist
     * @param tokenId The token ID of the minted token
     */
    function getProperties(uint256 tokenId) external view returns (Properties memory properties);

    /**
     * @notice Sets the properties of the `tokenId` token
     *
     * IMPORTANT: Properties required to be set when minting a token
     *
     * @param tokenId The ID of the token
     * @param properties The properties of the token
     */
    function setProperties(uint256 tokenId, Properties calldata properties) external;
}
