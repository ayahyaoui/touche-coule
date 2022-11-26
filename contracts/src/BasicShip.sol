// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import './Ship.sol';
import 'hardhat/console.sol';

contract BasicShip is Ship
{
  uint nextPos;
  uint height;
  uint width;
  uint posShip;

  constructor() 
  {
    nextPos = 49;
  }

  function update(uint x, uint y) public  override(Ship)
  {
    posShip = x + y * width;
    console.log("BasicShip:Update prorpio [", msg.sender, "] bateau: ");
    console.log(address(this), "position", posShip);
  }

  function fire() public override(Ship) returns (uint, uint) 
  {
    nextPos = nextPos + 1;
    if (nextPos == posShip)
      nextPos++;
    console.log("BasicShip:Fire");//, this, "en pos", nextPos);
    return (nextPos % width, nextPos / height);
  }

  function place(uint _width, uint _height) public override(Ship) returns (uint, uint)
  {
    width = _width;
    height = _height;
    console.log("BasicShip:place prorpio [", msg.sender, "] bateau: ");
    console.log(address(this), "try position 1,1 =>", width + 1);
    return (1, 1);
  }
}
