# Capstone Project, FRE-GY 9163 Blockchain and Cryptocurrency

## Developer: Shiran Zhang, sz3739@nyu.edu

## Implementation

### KafkaToken

I implemented a simple token called KafkaToken after `IERC20` interface. It has basic function of `mint`, `approve`, `transfer` and `transferFrom`.

With `mint` function, everyone who participates in this token can mint any amount they want. By calling `balanceOf` function, users can know how much token they own. By calling `totalSupply` function, users can have an overview of the total token supply.

With `approve` function, users can add any smart contracts they want to interact with into the allowance list. By calling `allowance` function, users can know what contracts they have approved.

With `transfer` and `transferFrom`, token holders can transfer to any address and withdraw their token from all the contracts that they have approved.

### AMM

I also implemented a simple constant sum auto market maker (AMM). In this AMM, price of tokens are determined by the equation `X + Y = K`, where `X` is the amount of token A in the AMM and `Y` is the amount of token B in the AMM, while `K` is a constant.

With calculation, we can see that when users want to trade from token A to token B tokens, it follows the rule of `dx = dy`, where `dx` is the amount of token A in and `dy` is the amount of token B out.

When users want to add liquidity, the amount of shares to mint follow the rule of `shares_to_mint = (dx + dy) * total_shares_before_mint / (X + Y)`.

When users want to remove liquidity, the amount of shares to burn follow the rule of `dx = shares_to_burn / total_shares * X` and `dy = shares_to_burn / total_shares * Y`.

## How to Run

I have only deployed KafkaToken on Goerli Testnet due to limited account ETH. Here's the etherscan link: https://goerli.etherscan.io/tx/0x9a94d82f2991ea47f5ce69895c32bc685437a4649bf72407f337ad6d9dc37bf8.
