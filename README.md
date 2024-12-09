# P2P-Lending

## Table of Contents

- [About the Project](#about-the-project)
  - [Challenges](#challenges)
  - [Built With](#built-with)
  - [Installation](#installation)

<!-- ABOUT THE PROJECT -->

## About The Project

**CPSC 559:** Advanced Blockchain
**Professor:** Wenlin Han

**Project Title:** Decentralized Peer-to-Peer Lending Platform

# Team MetaZombies

1. Drashti Mehta - 889212452 - dumehta@csu.fullerton.edu

2. Jainish Shah - 885154104 - jainishshah0124@csu.fullerton.edu

3. Hiral Pokiya - 818055535 - hiral14@csu.fullerton.edu

4. Sai Preethi Mekala - 881461081 - saipreethi@csu.fullerton.edu

This project explores the implementation of smart contracts for a Decentralized Autonomous Organization (DAO) focused on creating a decentralized peer-to-peer lending platform on the Ethereum blockchain. The platform leverages blockchain technology to enable fair, transparent, and global lending opportunities, effectively serving as a decentralized alternative to traditional banking systems.

The open ecosystem of this platform aims to provide more accessible and affordable lending options by eliminating intermediaries and reducing overhead costs. Additionally, it empowers users worldwide to engage in lending and borrowing with confidence in a secure and decentralized environment. The DAO structure allows for adaptability and potential future growth, driven by collective decisions of its participants.

This project demonstrates the practical application of blockchain principles, emphasizing smart contract design, decentralization, and transparency, aligning with the objectives of CPSC 559: Advanced Blockchain.


### Built With

- [Node 18](https://nodejs.org/en/)
- [Truffle](https://truffleframework.com/truffle)
- [Vue.js](https://vuejs.org/)
- [web3.js](https://web3js.readthedocs.io/en/1.0/getting-started.html)

### Installation

1. Clone the repo

   ```sh
   git clone https://github.com/adorsys/p2p-lending.git
   ```

2. Run Ganache on port 8545

   ```sh
   Ganache -> Settings -> Server -> Port Number -> 8545
   ```

3. Install dependencies

   ```sh
   npm install
   ```

4. Compile Smart Contracts

   ```sh
   truffle compile
   ```

5. Deploy Smart Contracts to local blockchain

   ```sh
   npm run migrate:dev
   ```

6. Switch to frontend folder

   ```sh
   cd frontend
   ```

7. Install frontend dependencies

   ```sh
   npm install
   ```

8. Start frontend

   ```sh
   npm start
   ```

9. Open the DApp in your favorite browser

   ```sh
   localhost:8080
   ```
