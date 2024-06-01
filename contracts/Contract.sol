// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MyContract {
  uint256 totalBeer;
  address payable public owner;

  constructor() payable {
    owner = payable(msg.sender);
  }

  event NewBeer (
    address indexed from,
    uint256 timestamp,
    string message,
    string name
  );

  struct Beer {
    address sender;
    string message;
    string name;
    uint256 timestamp;
  }

  Beer[] beer;
  
  function getAllBeer() public view returns (Beer[] memory) {
    return beer;
  }

  function getTotalBeer() public view returns (uint256) {
    return totalBeer;
  }

  function buyBeer(
    string memory _message,
    string memory _name
  ) payable public {
    require(msg.value == 0.01 ether, "You should give me 0.01");

    totalBeer += 1;
    beer.push(Beer(msg.sender, _message, _name, block.timestamp));

    (bool success,) = owner.call{value: msg.value}("");
    require(success, "Failed to send Ether to owner");

    emit NewBeer(msg.sender, block.timestamp, _message, _name);
  }

}
