//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { ERC721 } from "@openzeppelin/contracts-v4/token/ERC721/ERC721.sol";
import { IERC7578, Properties, Amount } from "../interfaces/IERC7578.sol";

/**
 * @title ERC7578
 * @author DESAT
 * @notice Implementation of the ERC-7578: Physical Asset Redemption standard compatible with the OpenZeppelin v4 library
 **/
contract ERC7578Legacy is IERC7578, ERC721 {
    /**
     * @notice Initializes the ERC721 dependency contract by setting a `name` and a `symbol` to the token collection
     */
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    /**
     * @notice Token properties based on the ID of the token
     */
    mapping(uint256 tokenId => Properties) private _properties;

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
     * @notice Override of the {_safeMint} function to check if the properties of the `tokenId` token are set
     * @param to The address to mint the token to
     * @param tokenId The ID of the token to mint
     */
    function _safeMint(address to, uint256 tokenId) internal virtual override {
        require(bytes(_properties[tokenId].tokenIssuer).length != 0, "Properties not initialized");
        super._safeMint(to, tokenId);
    }

    /**
     * @notice Override of the {_burn} function to remove the properties of the `tokenId` token
     * @param tokenId The ID of the token being burned
     */
    function _burn(uint256 tokenId) internal virtual override {
        _removeProperties(tokenId);
        super._burn(tokenId);
    }
}
