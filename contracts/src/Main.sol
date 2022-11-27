// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import './Ship.sol';
import 'hardhat/console.sol';
import './BasicShip.sol';


struct Game {
  uint height;
  uint width;
  mapping(uint => mapping(uint => uint)) board;   // represents the board: a cell contains the index of the ship in it or 0 if there is no ship
  mapping(uint => int) xs;             // the coordinate of each ship on the x axis (-1 is the ship was sinked)
  mapping(uint => int) ys;             // the coordinate of each ship on the y axis
}

contract Main {
  Game private game;
  uint private index;   // the total number of ships on the board + 1
  mapping(address => bool) private used;    // indicates whether the ship (which has a contract address) is on the board
  mapping(uint => address) private ships;   // lists the ships that are on the board (associate a number with their contract address)
  mapping(uint => address) private owners;  // lists the owner of each ship (through the ship numbers)
  mapping(address => uint) private count;   // the player's address is mapped to the number of ships he has
  bool startGame;

  event Size(uint width, uint height);
  event Touched(uint ship, uint x, uint y);
  event Flop(uint x, uint y);
  event Registered(
    uint indexed index,
    address indexed owner,
    uint x,
    uint y
  );

  constructor() {
    game.width = 50;
    game.height = 50;
    index = 1;
    startGame = false;
    emit Size(game.width, game.height);
  }

  // Adds a ship on the board
  function register(address ship) public  {
    require(count[msg.sender] < 2, 'Only two ships allowed per player');
    require(!used[ship], 'Ship already on the board');
    require(index <= game.height * game.width, 'Too many ships on the board');
    require(!startGame);
    
    count[msg.sender] += 1;
    ships[index] = ship;
    owners[index] = msg.sender;
    used[ship] = true;
    
    (uint x, uint y) = placeShip(index);
    Ship(ships[index]).update(x, y);
    emit Registered(index, msg.sender, x, y);
    index += 1;
  }

  function register2() external{
    require(count[msg.sender] < 2, 'Only two ships allowed per player');
    require(index <= game.height * game.width, 'Too many ships on the board');
    Ship tmp = new BasicShip();
    register(address(tmp)); // address inutile car tmp est deja une address
  }

  // Makes all the remaining ships fire and updates the game if a ship is touched
  function turn() external {
    console.log("Main.sol:Turn start");
    startGame = true;
    bool[] memory touched = new bool[](index); // for each ship that is still ingame, indicates whether it was touched this round

    for (uint i = 1; i < index; i++) {
      if (game.xs[i] < 0) continue;

      Ship ship = Ship(ships[i]);
      /*(uint x, uint y) = ship.fire();
      console.log("Main.sol: Turn fire for ", address(ship));
      if (game.board[x][y] > 10) { // msg.sender est generalement tres grand donc utilise les premier nombre pour autre chose
        touched[game.board[x][y]] = true;
      }
      else if (game.board[x][y] == 0){
        emit Flop(x, y); // on se permet emit avant car cela n'a pas impact
        game.board[x][y] = 2;*/ // TODO set global constante ? 

      bool invalid = true;
      while(invalid){
        (uint x, uint y) = ship.fire();
        console.log("Main.sol: Turn fire for ", address(ship));

        if (game.board[x][y] == 0) invalid = false;

        // Prevents ships from firing on their allies
        if (game.board[x][y] > 0) {
          if(owners[game.board[x][y]] != owners[i]) {
            touched[game.board[x][y]] = true;
            invalid = false;
          }
        }
        // Tells the allied ships which position was targeted
        if(!invalid){
          for (uint j = 1; j < index; j++) {
            if (game.xs[j] < 0) continue;
            
            if(j != i && owners[j] == owners[i]) {
              Ship(ships[j]).alreadyTargeted(x, y);
              break; // There can only be one ally
            }
          }
        }
      }
    }
    for (uint i = 0; i < index; i++) {
      if (touched[i]) {
        emit Touched(i, uint(game.xs[i]), uint(game.ys[i]));
        game.xs[i] = -1;
      }
    }
  }

  // Places the ship n° 'idx' on the board
  function placeShip(uint idx) internal returns (uint, uint) {
    Ship ship = Ship(ships[idx]);
    (uint x, uint y) = ship.place(game.width, game.height);
    bool invalid = true;

    while (invalid) {
      // Places the ship if the cell is empty
      if (game.board[x][y] == 0) {
        game.board[x][y] = idx;
        game.xs[idx] = int(x);
        game.ys[idx] = int(y);
        invalid = false;
      }
      // Calculates a new position otherwise
      else {
        uint newPlace = (y * game.width) + x + 1;
        x = newPlace % game.width;
        y = newPlace / game.width;

        if (newPlace == game.width * game.height) // restart (index out of range)
        {
          x = 0;
            y = 0;
        }
      }
    }
    return (x, y);
  }
}
