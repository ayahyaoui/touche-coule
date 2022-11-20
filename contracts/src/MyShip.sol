// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import './Ship.sol';
import 'hardhat/console.sol';

contract MyShip is Ship
{
  uint height;
  uint width;
  uint[] myMap;
  uint[] nextFire;
  uint shipPos;
  uint indexNextFire;
  uint lastTargeted;
  uint public constant MYSHIP = 42;
  uint public constant TEAMSHIP = 3; // later (maybe)
  uint public constant TARGETED = 2; // already targeted box

  constructor() {
    lastTargeted = 0;
    width = 0;
    height = 0;
  } 

  /*
    called when we get the format of the map (first place)
  */
  function initialiseData(uint _width, uint _height) external
  {
    width = _width;
    height = _height;
    myMap = new uint[](width * height);
    indexNextFire = 0;
    // if myMap is not initialise with 0
  }

  /*
      if the main contract give us an position 
      not corresponding to our position we stock the difference on nextFire
      to prioritize 
      (very unlikely)
  */
  function update(uint _x, uint _y) public override(Ship)
  {
    uint NewPos = _x + _y * width;

    while (NewPos > shipPos && shipPos < width * height)
    {
      nextFire.push(shipPos);
      shipPos += 1;
    }
    if (shipPos == width * height)
      shipPos = 0;
    while (NewPos > shipPos)
    {
      nextFire.push(shipPos);
      shipPos+= 1;
    }
  }

  function fire() public override(Ship) returns (uint, uint)
  {
      uint posFire;

      while (indexNextFire < nextFire.length)
      {
        posFire = nextFire[indexNextFire];
        indexNextFire++;
        if (myMap[posFire] == 0)
        {
          //console.log(msg.sender +  "tire sur la case " + posFire + " depuis l'adresse ");
          myMap[posFire] = TARGETED;
          return (posFire % width, posFire / width);
        }
      }
      while(myMap[lastTargeted] != 0)
        lastTargeted++;
      myMap[lastTargeted] = TARGETED;
          return (lastTargeted % width, lastTargeted / width);
      

  }

  /*
    Pour le moment genere des positions selon l'adresse de celui qui paye les frais
    (Surtout pour le debug avoir les  meme position).
  */
  function place(uint _width, uint _height) public override(Ship) returns (uint, uint)
  {
    uint x = uint(keccak256("42"/*msg.sender*/)) % _width;
    uint y = uint(keccak256("42"/*msg.sender*/)) % _height;

    this.initialiseData(_width, _height);
    console.log("Called function ====> Place");
    shipPos = x + y * width;
    return (x, y);
  }
}
