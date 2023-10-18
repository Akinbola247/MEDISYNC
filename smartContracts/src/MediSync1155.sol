// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts.git/contracts/token/ERC1155/ERC1155.sol";

contract MediSync1155 is ERC1155 {   
    address owner;

    constructor(string memory _uri) ERC1155(_uri){
        owner = msg.sender;
    }

    //Function to mint nft type
    function Mint(address to, uint id, uint amount) external{
       //caller checks and gating option goes in here
        require(to != address(0), 'non-zero');
        _mint(to, id, amount, '');
    }

    //Function to give organization ability to revoke certificate if need arises
    function Burn(address from, uint id, uint amount) external {
       //caller checks and gating option goes in here
        require(from != address(0), 'non-zero');
        _burn(from, id, amount);
    }
    
    //over-rides for non transferability
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        revert('non-transferable');
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public override {
       revert('non-transferable');
    }

}