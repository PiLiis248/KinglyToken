// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract KingLyToken is ERC20, Ownable, ReentrancyGuard {
    mapping(address => bool) public blacklist;
    uint256 public constant MAX_SUPPLY = 100_000_000_000 * 10**18;
    constructor() ERC20("KingLyToken", "KLT") Ownable(msg.sender) {
        _mint(msg.sender, MAX_SUPPLY);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override nonReentrant returns (bool) {
        require(!blacklist[sender] && !blacklist[recipient], "Blacklisted");
        _spendAllowance(sender, msg.sender, amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded" ); 
        _mint(to, amount); 
    } function burn(uint256 amount) external { 
        _burn(msg.sender, amount); 
    } function addToBlacklist(address user) external onlyOwner { 
        blacklist[user]=true; 
    } function removeFromBlacklist(address user) external onlyOwner {
        blacklist[user]=false; 
    } 
}