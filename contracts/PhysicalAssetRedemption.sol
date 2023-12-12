//SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IPhysicalAssetRedemption.sol";

/**
 * @title Physical Asset Redemption Contract
 * @author DeSAT
 * @notice Contract for Physical Asset Redemption Standard
 **/
contract PhysicalAssetRedemption is IPhysicalAssetRedemption, ERC721 {
    /**
     * @notice Constructor for the PhysicalAssetRedemption contract
     * @param _name The name of the token
     * @param _symbol The symbol of the token
     */
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {}

    mapping(uint256 => Properties) public properties;

    /**
     * @notice Properties required to be set when minting a token
     * @param id The token id of the initialized token. Should be greater than 0.
     * @param tokenIssuer The network or entity minting the tokens
     * @param assetHolder The legal owner of the physical asset
     * @param storedLocation The physical storage location
     * @param terms Link to IPFS contract, agreement or terms
     * @param jurisdiction The legal justification set out in the terms
     * @param declaredValueCurrency The declared value currency at time of token minting
     * @param declaredValueAmount The declared value amount at time of token minting
     */
    function setProperties(
        uint256 id,
        string memory tokenIssuer,
        string memory assetHolder,
        string memory storedLocation,
        string memory terms,
        string memory jurisdiction,
        string memory declaredValueCurrency,
        uint256 declaredValueAmount
    ) public {
        require(id > 0, "Token id must be greater than 0");
        properties[id] = Properties({
            tokenId: id,
            tokenIssuer: tokenIssuer,
            assetHolder: assetHolder,
            storedLocation: storedLocation,
            terms: terms,
            jurisdiction: jurisdiction,
            declaredValue: Amount({
                currency: declaredValueCurrency,
                value: declaredValueAmount
            })
        });

        emit PropertiesSet(properties[id]);
    }

    /**
     * @notice internal function to remove the properties of a token
     * @param _tokenId The token id of the minted token
     */
    function _removeProperties(uint256 _tokenId) internal {
        delete properties[_tokenId];
        emit PropertiesRemoved(properties[_tokenId]);
    }

    /**
     * @notice override of the _safeMint function to check if properties are set
     * @param to The address to mint the token to
     * @param id The token id of the token to mint
     */
    function _safeMint(address to, uint256 id) internal virtual override {
        require(properties[id].tokenId > 0, "Properties not initialized");
        super._safeMint(to, id);
    }

    /**
     * @notice override of the _burn function to remove properties
     * @param id The token id of the minted token
     */
    function _burn(uint256 id) internal virtual override {
        _removeProperties(id);
        super._burn(id);
    }
}
