// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {
    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokenIndex;

    // mapping of owner to list of all owner token Ids
    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    // function tokenByIndex(uint256 _index) external view returns (uint256) {}

    // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {}

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokenIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply(), "Token index is out of bounds");
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        returns (uint256)
    {
        require(index < balanceOf(owner), "Owner index  is out of bounds");
        return _ownedTokens[owner][index];
    }
}
