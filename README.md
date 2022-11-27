# Touché Coulé
Anas Yahyaoui, Clément Gresh, Emeline Centaure        
2022 - 2023 

# Overview

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

# Install

You’ll need to install dependencies. You’ll need [`HardHat`](https://hardhat.org/), [`Node.js`](https://nodejs.org/en/), [`NPM`](https://www.npmjs.com/) and [`Yarn`](https://yarnpkg.com/). You’ll need to install [`Metamask`](https://metamask.io/) as well to communicate with your blockchain.

- `HardHat` is a local blockchain development, to iterate quickly and avoiding wasting Ether during development. Fortunately, you have nothing to do to install it.
- `Node.js` is used to build the frontend and running `truffle`, which is a utility to deploy contracts.
- `NPM` or `Yarn` is a package manager, to install dependencies for your frontend development. Yarn is recommended.
- `Metamask` is a in-browser utility to interact with decentralized applications.

Once everything is installed, launch the project (with `yarn dev`). You should have a local blockchain running in local. Open Metamask, setup it, and add an account from the Private Keys HardHat displays.
Now you can connect Metamask to the blockchain. To do this, add a network by clicking on `Ethereum Mainnet` and `personalized RPC`. Here, you should be able to add a network.

![Ganache Config](public/ganache-config.png)

Once you have done it, you’re connected to the HardHat blockchain!

# Launch

Install dependancies						yarn

Launch project							    yarn dev

Connect to MetaMask on your browser

Make sure you are using the HardHat network

Open http://localhost:5173/

On Metamask :
    • click on « import account »
    • use one of the 20 private keys generated in the terminal. It creates an account 1000 ETH.
    • creates as many accounts as you want players.
    • make sure the accounts are « connected », click on « non connected » otherwise

On Metamask, everytime you start a new game, reinitialize ALL the accounts :
    • wait for the 20 private keys to be generated
    • settings – advanced – reset account

