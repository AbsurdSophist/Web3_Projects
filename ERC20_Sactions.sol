// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenX is ERC20 {
    mapping(address => bool) private _blockedAddresses;
    address private _specialAddress;

    constructor() ERC20("TokenX", "TX") {
        _specialAddress = msg.sender;
    }

    // Allow specialAddress to add account to blockedAddresses
    function blockAddress(address account) external {
        require(
            msg.sender == _specialAddress,
            "Only the contract owner can block addresses"
        );
        _blockedAddresses[account] = true;
    }

    // Allow specialAddress to remove account from blockedAddresses
    function unblockAddress(address account) external {
        require(
            msg.sender == _specialAddress,
            "Only the contract owner can unblock addresses"
        );
        _blockedAddresses[account] = false;
    }

    // Allow to check if on blocked list
    function isAddressBlocked(address account) external view returns (bool) {
        return _blockedAddresses[account];
    }

    // Override transfer function to check if sender or recipient is blocked
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        require(!_blockedAddresses[from], "Sender is blocked");
        require(!_blockedAddresses[to], "Recipient is blocked");
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }
}
