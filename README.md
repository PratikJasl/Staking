# STAKING CONTRACT

**DESCRIPTION 📌** 
A staking contract is basically a code, which lets a user store a specific token let’s say “A” for a fixed amount of time, and in return, we get   a reward of token B.
Staking can be done for multiple reasons which includes:
* Staking is part of the Proof-of-Stake algorithm, where the miners who have staked the most will get the mining rights first.
* Network Popularity: Staking provides incentives to the participants. This encourages more and more people to become a part of the network and encourages the growth of the network.
* Network Stability: When individuals stake their tokens, it helps stabilize the network by reducing volatility and liquidity risks. By locking up their tokens, stakers make them less available for immediate trading or selling, thereby reducing potential market fluctuations.
* Decentralization: When normal individuals stake their tokens, it helps distribute the decision-making power and influence across a wider range of participants. This decentralized distribution of stakeholder engagement helps prevent the centralization of control.
* Security and Consensus: With a larger number of participants staking tokens, the network becomes more robust against attacks and ensures a higher level of security and trustworthiness.
* Staking can be of different types, Namely fixed Staking and Liquid Staking. This contract is an example of Liquid Staking.

**ALGORITHM 📌**
* Every time the User Stakes or Withdraws Calculate the Reward Per Token.
* Calculate Rewards earned by the User by subtracting the Reward at Claimed Time and Reward at the staked time, as shown in the example above.
* Update User reward per token staked.
* Store the last time someone Staked or Claimed.
* Update Staked amount by the user.

**TECHNOLOGY STACK 📌**
* Solidity
* JavaScript
* Hardhat
* Ether.js
