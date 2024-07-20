// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract KittyKash is ERC20 {
    uint256 internal constant TOKEN_PRICE = 1 ether / 1000; // 1000 tokens = 1 ether
    uint256 internal constant TOKENS_PER_PURCHASE = 1000; // 1000 tokens with 18 decimal places
    uint256 public maxSupply = 1000000; // Default maxSupply to 1,000,000 tokens with 18 decimal places
    address payable public owner;

    constructor() payable ERC20("TokenSale", "TS") {
        owner = payable(msg.sender);
    }
}

contract OrigamiCats is ERC721, Ownable {
    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 10;
    uint256 public constant PRICE = 0 ether;
    address immutable deployer;

    constructor() Ownable(msg.sender) ERC721("OrigamiCats", "ORI") {
        deployer = msg.sender;
    }

    function mint() external payable {
        require(tokenSupply < MAX_SUPPLY, "Max supply met");
        require(msg.value == PRICE, "Wrong price");

        _safeMint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmcZiRBjALqx6NyA8TWJu9skkndhpxWWiSAS9EJNzPQKhW/";
    }

    function viewBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external onlyOwner {
        payable(deployer).transfer(address(this).balance);
    }

    function renounceOwnership() public pure override {
        require(false, "Cannot renounce");
    }

    function transferOwnership() public pure {
        require(false, "Cannot renounce");
    }
}

contract MintAKitty is IERC721Receiver {

    IERC721 public itemNFT;
    mapping(uint256 => address) public originalOwner;
    constructor(IERC721 _address) {
        itemNFT = _address;
    }
    