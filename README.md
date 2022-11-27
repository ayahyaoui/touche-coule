# Touché Coulé
Anas Yahyaoui, Clément Gresh, Emeline Centaure        
2022 - 2023 

The idea of this project is to implement a "Touché Coulé" (Battleship) game
in a decentralized way, on Ethereum. This will have cool side effects, like not
be forced to pay for servers.

Touché Coulé is implemented from scratch in Solidity. The game is running into a contract by its own. 

The idea of the game is to fight in a free for all style (every players will play in the same time) with ships. Each player have two ships, of size 1. At the beginning of the game, you're placing your ships on a grid (50x50). Every turn, your ships will be able to fire once. Your goal is to destroy all the opponents ships. In a second step, your ships will be able to talk to each other, and potentially to do some diplomacy with other ships.

# Features implemented

- Creation of ship by inheriting the base contract.
- Three strategies have been implemented and can be choosen with an option input : the inputs return a index which is then send as an argument 
  to shipFactory to choose which strategy to adopt for the new ship
- Different colors for the ship displaying when they are damaged by opponent attacks or intact
- Deployment. 
- Pop up displayed when a player win the game
- Alliances between ships 

