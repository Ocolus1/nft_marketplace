// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

contract ERC721 is ERC165, IERC721 {

    /*
        BUILDING OUT THE MINTING FUNCTION
        a. nft to point to an address
        b. keep track of the token ids
        c. keep track of token owner address to token ids
        d. keep track of how many tokens an owner address has
        e. an event that emits a transfer log - contract address,
        where it is been minted to , id  
    */


    mapping(uint => address) private _tokenOwner;
    mapping(address => uint) private _OwnedTokensCount;

    //mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^
        keccak256('transferFrom(bytes4)')));
    }


    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "owner query for non-existent token");
        return _OwnedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "owner query for non-existent token");
        return owner;
    }

    function _exists(uint tokenId) internal view returns(bool) {
        // checks if owner in _tokenOwner
        address owner = _tokenOwner[tokenId];
        // checks the truth value of the owner
        return owner != address(0);
    }

    function _mint (address to, uint tokenId) internal virtual {
        // require that the address is not zero
        require(to != address(0), "ERC721: minting to the zero address");
        // require that the token does not already exists
        require(!_exists(tokenId), "ERC721: token already minted");
        // adding a new address for token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of the amount of token minted by an address
        _OwnedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), "Error: ERC721 transfering to the zero address");
        require(ownerOf(_tokenId) == _from, "Error: ERC721 transfering token the address does not own");
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "Error: approval to current owner!");
        require(msg.sender == ownerOf(_tokenId), "Error: current caller is not the owner of the token");
        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), "Error: token does not exists");
        address owner = ownerOf(tokenId);
        return ( owner == spender );
    }
    
}