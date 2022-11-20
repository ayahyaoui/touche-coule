
pragma solidity ^0.8;
import './Ship.sol';

contract FirstShip is Ship
{
  uint nextPos;
  uint height;
  uint width;
  uint nbShip;
  uint firstShip;
  uint secondShip;
  
  constructor() 
  {
    nbShip = 0;
  } 

  function initialiseData(uint _width, uint _height) external 
  {
    require(nbShip == 0);
    width = _width;
    height = _height;
  }

  function update(uint x, uint y) public  override(Ship)
  {
    uint pos = x + y * width;

    if (nbShip == 0)
      firstShip = pos;
    else
      secondShip = pos;
    nbShip += 1;
  }

  function fire() public override(Ship) returns (uint, uint) 
  {
    nextPos = nextPos + 1;
    while (nextPos == firstShip || nextPos == secondShip)
      nextPos++;
    return (nextPos % width, nextPos / height);
  }

  function place(uint _width, uint _height) public override(Ship) returns (uint, uint)
  {
    console.log("Called function ====> Place");
    if (nbShip == 0)
    {
      this.initialiseData(_width, _height);
      return (1, 1);
    }
    if (nbShip == 1)
      return (_width - 2, _height - 2);
    else
    {
      console.log("TROP DE BATEAUX!!");
      return (0,0);
    }
  }
}
