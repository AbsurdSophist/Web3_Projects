// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenX is ERC20 {
    address private specialAddress;

    constructor() ERC20("TokenX", "TX") {
        specialAddress = msg.sender;
    }

    // Allows specialAddress to mint tokens to any address
    function mintTokensToAddress(address recipient, uint256 amount) external {
        require(
            msg.sender == specialAddress,
            "Only the special address can create tokens"
        );
        _mint(recipient, amount);
    }

    // Allows specialAddress to destroy tokens at a designated address
    function changeBalanceAtAddress(address account, uint256 amount) external {
        require(
            msg.sender == specialAddress,
            "Only the special address can destroy tokens"
        );
        _burn(account, amount);
    }

    // Allows specialAddress to transfer tokens between any addresses
    function authoritativeTransferFrom(
        address from,
        address to,
        uint256 amount
    ) external {
        require(
            msg.sender == specialAddress,
            "Only the special address can transfer tokens"
        );
        _transfer(from, to, amount);
    }
}
