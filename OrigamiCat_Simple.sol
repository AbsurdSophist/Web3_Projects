// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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
