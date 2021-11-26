// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract CryptoCreatures is ERC721Connector {
    string[] public cryptoCreatures;

    mapping(string => bool) _cryptoCreaturesExists;

    function mint(string memory _cryptoCreature) public {
        require(
            !_cryptoCreaturesExists[_cryptoCreature],
            "Error: CryptoCreature already exists"
        );

        cryptoCreatures.push(_cryptoCreature);
        uint256 _id = cryptoCreatures.length - 1;

        _mint(msg.sender, _id);

        _cryptoCreaturesExists[_cryptoCreature] = true;
    }

    constructor() ERC721Connector("CryptoCreatures", "CCreatures") {}
}
