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
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    mapping(uint256 tokenId => Properties) private _properties;

    /**
     * @inheritdoc IPhysicalAssetRedemption
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
    ) public {
        require(tokenId > 0, "Token id must be greater than 0");
        _properties[tokenId] = Properties({
            tokenIssuer: tokenIssuer,
            assetHolder: assetHolder,
            storedLocation: storedLocation,
            terms: terms,
            jurisdiction: jurisdiction,
            declaredValue: Amount({ currency: declaredValueCurrency, value: declaredValueAmount })
        });

        emit PropertiesSet(tokenId, _properties[tokenId]);
    }

    /**
     * @inheritdoc IPhysicalAssetRedemption
     */
    function getProperties(uint256 tokenId) public view override returns (Properties memory properties) {
        properties = _properties[tokenId];
    }

    /**
     * @notice internal function to remove the properties of a token
     * @param tokenId The token id of the minted token
     */
    function _removeProperties(uint256 tokenId) internal {
        delete _properties[tokenId];
        emit PropertiesRemoved(tokenId, _properties[tokenId]);
    }

    /**
     * @notice override of the _safeMint function to check if properties are set
     * @param to The address to mint the token to
     * @param tokenId The token id of the token to mint
     */
    function _safeMint(address to, uint256 tokenId) internal virtual override {
        require(bytes(_properties[tokenId].tokenIssuer).length != 0, "Properties not initialized");
        super._safeMint(to, tokenId);
    }

    /**
     * @notice override of the _burn function to remove properties
     * @param tokenId The token id of the minted token
     */
    function _burn(uint256 tokenId) internal virtual override {
        _removeProperties(tokenId);
        super._burn(tokenId);
    }
}
