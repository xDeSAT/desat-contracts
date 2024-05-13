//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { ERC721 } from "@openzeppelin/contracts-v5/token/ERC721/ERC721.sol";
import { IERC7578, Properties, Amount } from "./interfaces/IERC7578.sol";

/**
 * @title ERC7578
 * @author DESAT
 * @notice Implementation of the ERC-7578: Physical Asset Redemption standard
 **/
contract ERC7578 is IERC7578, ERC721 {
    /**
     * @notice Thrown when the properties of a token are not initialized
     */
    error PropertiesUninitialized();

    /**
     * @notice Retrieves the properties of the `tokenId` token
     */
    mapping(uint256 tokenId => Properties) private _properties;

    /**
     * @notice Initializes the ERC721 dependency contract by setting a `name` and a `symbol` to the token collection
     */
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    /**
     * @inheritdoc IERC7578
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
     * @inheritdoc IERC7578
     */
    function getProperties(uint256 tokenId) public view override returns (Properties memory properties) {
        properties = _properties[tokenId];
    }

    /**
     * @notice Removes the properties of the `tokenId` token
     * @param tokenId The ID of the token from which to remove the properties
     */
    function _removeProperties(uint256 tokenId) internal {
        delete _properties[tokenId];
        emit PropertiesRemoved(tokenId, _properties[tokenId]);
    }

    /**
     * @notice Override of the {_update} function to remove the properties of the `tokenId` token or
     * to check if they are set before minting
     * @param tokenId The ID of the token being minted or burned
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
