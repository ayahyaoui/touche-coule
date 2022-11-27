// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import './Ship.sol';
import 'hardhat/console.sol';

contract BasicShip is Ship
{
  uint private nextPos;
  uint private height;
  uint private width;
  uint private posShip;

  constructor() 
  {
    nextPos = 50;
  }

  function update(uint _x, uint _y) public override(Ship)
  {
    posShip = _x + _y * width;
    console.log("BasicShip:Update prorpio [", msg.sender, "] bateau: ");
    console.log(address(this), "position", posShip);
  }

  function fire() public override(Ship) returns (uint, uint) 
  {
    uint tmpPos = nextPos;
    calculateNextPos();
    console.log("BasicShip:Fire");//, this, "en pos", tmpPos);
    return (tmpPos % width, tmpPos / height);
  }

  function place(uint _width, uint _height) public override(Ship) returns (uint, uint)
  {
    width = _width;
    height = _height;
    console.log("BasicShip:place prorpio [", msg.sender, "] bateau: ");
    console.log(address(this), "try position 1,1 =>", width + 1);
    return (1, 1);
  }

  function alreadyTargeted(uint _x, uint _y) public override(Ship)
  {
    if(nextPos == _x + _y * width)
      calculateNextPos();
  }

  // Calculates the position where the ship will fire at the next turn
  function calculateNextPos() public
  {
    nextPos = nextPos + 1;
    if (nextPos == posShip)
      nextPos++;
  }
}
