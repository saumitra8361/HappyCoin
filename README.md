'# HappyCoin
HappyCoin is a coin/token replicating some of the basic functionalities of Crypto Coin. 

HappyCoin project is coded on Smart Contract using Solidity. This stage is the logic implementation of this project.
HappyCoin can be seen in developing in 3 stages, where 3rd stage is the mature one.

HappyCoin-Stage3.sol:
'Admined' functionalitiy replicates 'owned' feature which make sure that there is a owner of a HappyCoin which controls its core operations.

Functionalities/Operations:
1) transfer, transferFrom --> takes care of transfer of HappyCoin from one address to another.
2) approve --> grants approval to a spender.
3) mintToken --> simple replication of miniting of any token.
4) freezeAccounts --> freeze a spender and set approval to negative/false from approval list.
5) setPrice --> setting up the price for token.
6) buy --> buying of token.
7) sell --> selling of token.
8) giveBlockReward --> function to give miner a reward in case new block is mined.
9) proofOfWork --> simple proof of work replication.
10) killCoin --> kill a contract/coin.

Events:
1) Transfer --> fired when ever coin/funds are transfered.
2) FrozenFund --> fired when an account  is frozen.
