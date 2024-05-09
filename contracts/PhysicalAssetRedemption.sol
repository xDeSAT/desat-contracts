//SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.21;

import { ERC721 } from "@openzeppelin/contracts-v5/token/ERC721/ERC721.sol";
import { IPhysicalAssetRedemption, Properties, Amount } from "./interfaces/IPhysicalAssetRedemption.sol";

/**
 * @title Physical Asset Redemption Contract
 * @author DeSAT
 * @notice Contract for Physical Asset Redemption Standard
 **/
contract PhysicalAssetRedemption is IPhysicalAssetRedemption, ERC721 {
    /**
     * @dev Thrown when the properties of a token are not initialized
     */
    error PropertiesUninitialized();

    /**
     * @notice Token properties based on the token ID
     */
    mapping(uint256 tokenId => Properties) private _properties;

    /**
     * @notice Constructor for the PhysicalAssetRedemption contract
     * @param _name The name of the token
     * @param _symbol The symbol of the token
     */
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    /**
     * @inheritdoc IPhysicalAssetRedemption
     */
    function setProperties(uint256 tokenId, Properties calldata properties) public {
        _properties[tokenId] = Properties({
            tokenIssuer: properties.tokenIssuer,
            assetHolder: properties.assetHolder,
            storedLocation: properties.storedLocation,
            terms: properties.terms,
            jurisdiction: properties.jurisdiction,
            declaredValue: Amount({
                currency: properties.declaredValue.currency,
                value: properties.declaredValue.value
            })
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
     * @notice Internal function to remove the properties of a token
     * @param tokenId The token ID of the minted token
     */
    function _removeProperties(uint256 tokenId) internal {
        delete _properties[tokenId];
        emit PropertiesRemoved(tokenId, _properties[tokenId]);
    }

    /**
     * @notice Override of the {_update} function to remove the properties of a token or check if they are set before minting
     * @param tokenId The token ID of the minted or burned token
     */
    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        if (to == address(0)) {
            _removeProperties(tokenId);
        } else if (from == address(0)) {
            if (bytes(_properties[tokenId].tokenIssuer).length == 0) revert PropertiesUninitialized();
        }

        return super._update(to, tokenId, auth);
    }
}
