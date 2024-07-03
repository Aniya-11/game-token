// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Functionality
// Only contract owner can mint tokens
// Any user can transfer tokens (as long as they have enough balance)
// Only registered players can burn tokens



contract GameToken is ERC20, Ownable {

  struct Player {
    bool registered;
    uint256 level; // Added player level
  }

  mapping(address => Player) public players;

  constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {}

  function decimals() public view virtual override returns (uint8) {
    return 0;
  }

  function registerPlayer(address player) public onlyOwner {
    require(!players[player].registered, "Player is already registered");
    players[player].registered = true;
  }

  function mint(address to, uint256 amount) public onlyOwner {
    require(players[to].registered, "Player is not registered");
    _mint(to, amount);
  }

  function burn(address from) public {
    require(players[from].registered, "Player is not registered");
    require(balanceOf(from) > 0, "Insufficient balance to burn");
    _burn(from, balanceOf(from)); // Burn entire balance
  }

  function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
    require(balanceOf(from) >= amount, "Insufficient balance to transfer");
    return super.transferFrom(from, to, amount);
  }

  function getPlayerPoints(address player) public view returns (uint256) {
    require(players[player].registered, "Player is not registered");
    return balanceOf(player);
  }

  function getPlayerLevel(address player) public view returns (uint256) {
    require(players[player].registered, "Player is not registered");
    return players[player].level;
  }

  // You can add functions to update player level based on gameplay
  function increasePlayerLevel(address player, uint256 levelIncrease) public onlyOwner {
    require(players[player].registered, "Player is not registered");
    players[player].level += levelIncrease;
  }
}
