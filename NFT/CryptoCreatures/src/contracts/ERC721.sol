// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Requirements for minting:
    1. nft to point to an address
    2. keep track of the token Ids
    3. keep track of token owner addresses to token Ids
    4. keep track of how many tokens an owner address has
    5. create an event that emits a transfer log
*/

contract ERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _tokensOwnedCount;

    function balanceOf(address _owner) public view returns (uint256) {
        require(
            _owner != address(0),
            "ERC721: cannot be assigned to 0 address"
        );

        return _tokensOwnedCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: cannot be assigned to 0 address");

        return owner;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        // check that tokenId exists
        address owner = _tokenOwner[tokenId];

        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: cannot be minted to 0 address");
        require(!_exists(tokenId), "ERC721: token has already been minted");

        _tokenOwner[tokenId] = to;
        _tokensOwnedCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}
