// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoBird is ERC721Connector {
    // array to store our nft
    string[] public kryptobirdz;

    mapping(string => bool) _kryptobirdzExists;

    function mint(string memory _kryptobird) public {

        require(!_kryptobirdzExists[_kryptobird], "Error: Kryptobird already exists");
        kryptobirdz.push(_kryptobird);
        uint _id = kryptobirdz.length - 1;

        _mint(msg.sender, _id);

        _kryptobirdzExists[_kryptobird] = true;
    }

    constructor () ERC721Connector("KryptoBird", "KBIRDZ") {
    }
}