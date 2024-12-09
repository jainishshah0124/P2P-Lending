# P2P-Lending

## Table of Contents

- [P2P-Lending](#p2p-lending)
  - [Table of Contents](#table-of-contents)
  - [Nexus Finance](#nexus-finance)
  - [About The Project](#about-the-project)
  - [Built With](#built-with)
  - [Features](#features)
    - [Initial Investment Phase](#initial-investment-phase)
    - [Dashboard](#dashboard)
    - [Bank Admin](#bank-admin)
    - [Lending System](#lending-system)
  - [Installation](#installation)

<!-- ABOUT THE PROJECT -->
**CPSC 559:** Advanced Blockchain
**Professor:** Wenlin Han

**Project Title:** Decentralized Peer-to-Peer Lending Platform

## Nexus Finance

1. Drashti Mehta - 889212452 - dumehta@csu.fullerton.edu

2. Jainish Shah - 885154104 - jainishshah0124@csu.fullerton.edu

3. Hiral Pokiya - 818055535 - hiral14@csu.fullerton.edu

4. Sai Preethi Mekala - 881461081 - saipreethi@csu.fullerton.edu

## About The Project

This project explores the implementation of smart contracts for a Decentralized Autonomous Organization (DAO) focused on creating a decentralized peer-to-peer lending platform on the Ethereum blockchain. The platform leverages blockchain technology to enable fair, transparent, and global lending opportunities, effectively serving as a decentralized alternative to traditional banking systems.

The open ecosystem of this platform aims to provide more accessible and affordable lending options by eliminating intermediaries and reducing overhead costs. Additionally, it empowers users worldwide to engage in lending and borrowing with confidence in a secure and decentralized environment. The DAO structure allows for adaptability and potential future growth, driven by collective decisions of its participants.

This project demonstrates the practical application of blockchain principles, emphasizing smart contract design, decentralization, and transparency, aligning with the objectives of CPSC 559: Advanced Blockchain.


## Built With

- [Node 18](https://nodejs.org/en/)
- [Truffle](https://truffleframework.com/truffle)
- [Vue.js](https://vuejs.org/)
- [web3.js](https://web3js.readthedocs.io/en/1.0/getting-started.html)

## Features
### Initial Investment Phase
- **First Investment Window:** Opens for initial investments with a goal to reach 10 ETH.
- **Trust Tokens:** Investors contributing ETH in this phase will receive trust tokens, equally distributed once the goal of 10 - ETH is achieved.
- **Lending System Activation:** The lending system starts once the initial investment goal is met.
  
### Dashboard
- **Loan Overview:** Displays all available loans for lending, allowing accounts to lend and earn ETH.
- **Request Management:** Includes options to view all requests or filter loans requested by trusted users.
- **Trust Tokens Transfer:**
  - Accounts can transfer trust tokens to other accounts.
  - Trusted accounts, identified as holders of trust tokens, are marked in green.
- **Token Allowance Management:**
  - Accounts can approve other accounts to use their trust tokens.
  - Accounts can check the allowance for trust token usage and transfer tokens using "from" and "to" details with a specified value.

### Bank Admin
- **Admin Role:**
  - The address from which the contract was deployed becomes the initial Bank Admin.
  - Admin can add another admin with similar rights, including voting on key proposals.
- **Loan Fee Management:**
  - Bank Admin can propose changes to the loan fee.
  - Changes to the loan fee require approval via voting.
  - Once approved, the fee is updated.
- **Loan Settlement Process:**
  - Borrowers pay the loan fee along with the payback amount.
  - Lenders receive the payback amount.

### Lending System
- **Loan Requests:** Accounts can place lending requests by specifying the ETH amount and the desired payback amount.
- **Loan Fulfillment:** 
  - Any account can select a loan and provide funds.
  - Lender accounts are debited with the lent amount.
- **Fund Withdrawal:** Once a loan is fully funded, the requester can withdraw the requested ETH.
- **Loan Repayment:** Requesters repay the loan by depositing the payback amount and the loan fee.



## Installation
 
1. Clone the repo

   ```sh
   git clone https://github.com/jainishshah0124/P2P-Lending.git
   ```

2. Run Ganache on port 7545

   ```sh
   Ganache -> Settings -> Server -> Port Number -> 7545
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

