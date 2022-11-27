# Touché Coulé
Anas Yahyaoui, Clément Gresh, Emeline Centaure        
2022 - 2023 

The idea of this project is to implement a "Touché Coulé" (Battleship) game
in a decentralized way, on Ethereum. This will have cool side effects, like not
be forced to pay for servers.

Touché Coulé is implemented from scratch in Solidity. The game is running into a contract by its own. 

The idea of the game is to fight in a free for all style (every players will play in the same time) with ships. Each player has two ships, of size 1. At the beginning of the game, you're placing your ships on a grid (50x50). Every turn, your ships will be able to fire once. Your goal is to destroy all the opponents ships. Some ships be able to talk to each other, and potentially do some diplomacy with other ships.

# Features implemented

- The ships are created by inheriting the base contract Ship. They are then deployed.
- Three kinds of ships have been implemented. They can be choosen with a scrolling menu before clicking on the register button :
    - basicShip that are mainly for tests. They place themselves and fire at predetermined positions. They always accept alliances.
    - myShip that place themselves randomly. If the Main updates their position when registering, they will assume an enemy is at the initial position and fire there. Otherwise, they start firing at (0, 0). Then they just fire on the cell next to the previous one at the next turn. They accept alliances with other ships every other time.
    - Destroyer that determine their own position randomly. They remember where they and their allies have already fired to not target those positions again. If the Main updates their position when registering, they will assume an enemy is at the initial position and fire there. They refuse any alliances (except with the other ship of the player).
- The ships are green when registered, red when destroyed and cells become black when a ship missfires there.
- The party cannot start if there are not 2 players in game.
- It is not possible to register a ship anymore once the party has started (i.e. there was already a turn).
- The Main contract does not let the ships of a player fire at each other (or destroy themselves).
- The alreadyTargeted() allows a ship to not fire at a position where its ally already fired.
- The acceptPact() allows ships (not players) to form alliances : they simply tell each other where they fire to avoid firing at the same position. A ship can only be allied to one other ship who belongs to another player. Alliances cannot be formed if there are only 2 players in game. The Main is the one keeping track of the alliances and allowing the allied ships to communicate with each other

