# 🏆 Provably Random Raffle Smart Contract

## 🎯 Overview
This project implements a provably fair raffle system using Chainlink VRF for randomness and Chainlink Automation for scheduled execution.

## 🚀 Features
* 🎟 **User Participation**: Users can enter the raffle by purchasing a ticket.
* 🏅 **Fair Winner Selection**: After a set period, a winner is randomly selected.
* 🤖 **Automated Execution**: The process is entirely automated using smart contracts.
* 🔗 **Chainlink Integration**:
    * VRF (Verifiable Random Function) ensures randomness.
    * Automation triggers the raffle draw at predefined intervals.

## 🛠️ Testing
The contract is tested across different environments:

* **Local Development**: Unit tests on a local blockchain.
* **Forked Testnet**: Simulating a live testnet environment.
* **Forked Mainnet**: Ensuring compatibility with mainnet conditions.

⚠ **Note**: Deployment is not currently compatible with zkSync.
