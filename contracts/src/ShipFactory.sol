

pragma solidity ^0.8;
import './Ship.sol';
import './MyShip.sol';
import './BasicShip.sol';

contract ShipFactory
{
    Ship[] allShips;
    // list of constructor to take randomly


    /*
        TODO
        Si possible avoir un tableaux static de constructeur pour 
        eviter une foret de if mais une seule ligne 
        du genre:
        index = randInt(size(tab))
        ship = new tab[index]();

    */
    function createShip() external returns (Ship)
    {
        // choose randomly an implementation of interface ship 
        //uint(keccak256(abi.encodePacked(now,msg.sender,randNonce))) % 2;
        return new FirstShip();
    }
    function createShip(uint _id) external returns (Ship)
    {
        Ship ship;

        if (_id % 2 == 0)
            ship = new FirstShip();
        else
            ship = new MyShip();
        allShips.push(ship);
        return ship;
    }
}