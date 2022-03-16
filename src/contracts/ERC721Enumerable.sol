// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./interfaces/IERC721Enumerable.sol";

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    // mapping frok token id to position of in _allToken array
    mapping(uint => uint) private _allTokenIndex;

    // mapping of owner to list of all token ids
    mapping(address => uint[]) private _ownedTokens;

    // mapping of token id index of the owner tokens list
    mapping(uint => uint) private _ownedTokenIndex; 

    constructor() {
        _registerInterface(bytes4(keccak256('tokenSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^
        keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }

    /// Enumerate valid NFTs
    ///  Throws if `_index` >= `totalSupply()`.
    /// A counter less than `totalSupply()`
    /// The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) public override view returns (uint256) {
        require(_index < totalSupply(), "Global index is out of bounds!");
        return _allTokens[_index];
    }

    /// Enumerate NFTs assigned to an owner
    /// Throws if `_index` >= `balanceOf(_owner)` or if
    /// `_owner` is the zero address, representing invalid NFTs.
    /// An address where we are interested in NFTs owned by them
    ///  A counter less than `balanceOf(_owner)`
    /// The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) public override view returns (uint256) {
        require(_index < balanceOf(_owner), "Owner index is out of bounds!");
        return _ownedTokens[_owner][_index];
    }

    function _mint (address to, uint tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        _addTokensToTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToTokenEnumeration (uint256 tokenId) private {
        _allTokens.push(tokenId);
        _allTokenIndex[tokenId] = _allTokens.length;
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokens[to].push(tokenId);
        _ownedTokenIndex[tokenId] = _ownedTokens[to].length;
    }

}