// SPDX-License-Identifier: MIT

pragma solidity ^0.8;
import './Ship.sol';
import 'hardhat/console.sol';

uint constant MYSELF = 1;
uint constant ENEMY = 2;
uint constant ALREADY_TARGETED = 3;

struct SmallGame {
    uint height;
    uint width;
    mapping(uint => mapping(uint => uint)) board;   // represents the board
}

// This kind of ship costs more to use since it reproduces the board but is very effective since
// it records all the information it has access to
contract DestroyerShip is Ship {
    SmallGame private game;

    function update(uint _x, uint _y) public override(Ship) {
        // Indicates there might be an enemy in the cell initially chosen
        if(game.board[_x][_y] != MYSELF){
            bool found = false;

            for (uint j = 1; j < game.width; j++) {
                for (uint i = 1; i < game.height; i++){
                    if(game.board[j][i] == MYSELF){
                        game.board[j][i] = ENEMY;
                        found = true;
                        break;
                    }
                }
                if(found) break;
            }
            game.board[_x][_y] = MYSELF;
        }
    }

    function fire() public override(Ship) returns (uint fire_x, uint fire_y) {
        // Looks for a known enemy
        for (uint j = 1; j < game.width; j++) {
            for (uint i = 1; i < game.height; i++){
                if(game.board[j][i] == ENEMY){
                    game.board[j][i] = ALREADY_TARGETED;
                    return(j, i);
                }
            }
        }
        // Fires randomly to a position that wasn't already targeted otherwise
        uint count = 0;

        while(true){
            count ++;
            uint position = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % (game.width * game.height);
            uint x = position % game.width;
            uint y = position / game.height;
            if(game.board[x][y] == 0) {
                game.board[x][y] = ALREADY_TARGETED;
                return(x, y);
            }
            // If it takes too long to find where to attack randomly,
            // just looks on the board for a position that was not attacked yet
            if(count > 100){
                for (uint j = 1; j < game.width; j++) {
                    for (uint i = 1; i < game.height; i++){
                        if(game.board[j][i] == 0){
                            game.board[j][i] = ALREADY_TARGETED;
                            return(j, i);
                        }
                    }
                }
            }
        }
    }

    function place(uint _width, uint _height) public override(Ship) returns (uint, uint) {
        game.width = _width;
        game.height = _height;
        uint position = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % (_width * _height);
        uint x = position % _width;
        uint y = position / _height;
        game.board[x][y] = 1;
        return (x, y);
    }

    function alreadyTargeted(uint _x, uint _y) public override(Ship) {
        if(game.board[_x][_y] != MYSELF)
            game.board[_x][_y] = ALREADY_TARGETED;
    }

    function acceptPact(uint id) public pure override(Ship) returns (bool){
    return false;  
    }
}