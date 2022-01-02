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

import "./interfaces/IERC721.sol";
import "./ERC165.sol";

contract ERC721 is ERC165, IERC721 {
    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _tokensOwnedCount;
    mapping(uint256 => address) private _tokenApprovals;

    function balanceOf(address _owner) public view returns (uint256) {
        require(
            _owner != address(0),
            "ERC721: cannot be assigned to 0 address"
        );

        return _tokensOwnedCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view override returns (address) {
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

    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "Error - approval to current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of the token"
        );

        _tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _to != address(0),
            "ERC721: cannot be transferred to 0 address"
        );
        require(
            ownerOf(_tokenId) == _from,
            "Cannot transfer token that is not owned"
        );

        _tokensOwnedCount[_from] -= 1;
        _tokensOwnedCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        _transferFrom(_from, _to, _tokenId);
    }
}
