// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import './Ship.sol';

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
  }

  function fire() public override(Ship) returns (uint, uint) 
  {
    console.log("BasicShip:Fire", nextPos);
    nextPos = nextPos + 1;
    if (nextPos == posShip)
      nextPos++;
    return (nextPos % width, nextPos / height);
  }

  function place(uint _width, uint _height) public override(Ship) returns (uint, uint)
  {
    console.log("Called function ====> Place");
    width = _width;
    height = _height;
    return (1, 1);
  }
}
