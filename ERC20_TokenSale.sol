// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KittyKash is ERC20 {
    uint256 internal constant TOKEN_PRICE = 1 ether / 1000; // 1000 tokens = 1 ether
    uint256 internal constant TOKENS_PER_PURCHASE = 1000; // 1000 tokens with 18 decimal places
    uint256 public maxSupply = 1000000; // Default maxSupply to 1,000,000 tokens with 18 decimal places
    address payable public owner;

    constructor() payable ERC20("TokenSale", "TS") {
        owner = payable(msg.sender);
    }

    // Allows user to buy 1000 tokens for 1 ether. Tokens are minted to user, maxSupply is reduced by 1000, and contract balance is increased by 1 ether
    function buyTokens() external payable {
        require(msg.value == 1 ether, "Must send exactly 1 ether");

        uint256 tokenAmount = TOKENS_PER_PURCHASE; // Fixed amount of 1000 tokens
        require(
            totalSupply() + tokenAmount <= maxSupply,
            "Exceeds maximum supply"
        );

        _mint(msg.sender, tokenAmount);
        maxSupply -= tokenAmount;

        if (maxSupply == 0) {
            payable(owner).transfer(address(this).balance);
        }
    }

    // Allows owner to withdraw contract balance
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        owner.transfer(balance);
    }
}

contract OrigamiCats is ERC721