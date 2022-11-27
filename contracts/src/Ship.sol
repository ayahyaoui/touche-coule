// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import 'hardhat/console.sol';

abstract contract Ship {
  function update(uint _x, uint y) public virtual;
  function fire() public virtual returns (uint, uint);
  function place(uint _width, uint _height) public virtual returns (uint, uint);

  // Informs the ship that the location was already targeted
  function alreadyTargeted(uint _x, uint _y) public virtual;
}

