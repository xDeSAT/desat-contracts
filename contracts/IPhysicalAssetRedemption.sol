//SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.21;

/**
 * @notice A struct containing data for redemption properties
 * @param tokenIssuer The network or entity minting the tokens
 * @param assetHolder The legal owner of the physical asset
 * @param storedLocation The physical storage location
 * @param terms  Link to IPFS contract, agreement or terms
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
 * @notice A struct for amount values
 * @param currency The currency of the amount
 * @param value The value of the amount
 */
struct Amount {
    string currency;
    uint256 value;
}

/**
 * @notice Interface for the PhysicalAssetRedemption contract
 */
interface IPhysicalAssetRedemption {
    /**
     * @notice Emitted when properties are set
     * @param tokenId The ID of the token
     * @param properties The properties of the token
     */
    event PropertiesSet(uint256 indexed tokenId, Properties properties);
    /**
     * @notice Emitted when properties are removed
     * @param tokenId The ID of the token
     * @param properties The properties of the token
     */
    event PropertiesRemoved(uint256 indexed tokenId, Properties properties);

    /**
     * @notice Retrieves all the properties of a token
     * @param tokenId The token ID of the minted token
     */
    function getProperties(uint256 tokenId) external view returns (Properties memory properties);

    /**
     * @notice Properties required to be set when minting a token
     * @param tokenId The token ID of the minted token
     * @param tokenIssuer The network or entity minting the tokens
     * @param assetHolder The legal owner of the physical asset
     * @param storedLocation The physical storage location
     * @param terms Link to IPFS contract, agreement or terms
     * @param jurisdiction The legal justification set out in the terms
     * @param declaredValueCurrency The declared value currency at time of token minting
     * @param declaredValueAmount The declared value amount at time of token minting
     */
    function setProperties(
        uint256 tokenId,
        string memory tokenIssuer,
        string memory assetHolder,
        string memory storedLocation,
        string memory terms,
        string memory jurisdiction,
        string memory declaredValueCurrency,
        uint256 declaredValueAmount
    ) external;
}
