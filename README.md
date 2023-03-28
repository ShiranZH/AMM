# AMM

## Implementation

### KafkaToken

I implemented a simple token called KafkaToken after `IERC20`. It has basic function of `mint`, `approve`, `transfer` and `transferFrom`.

With `mint` function, everyone who participates in this token can mint any amount they want. By calling `balanceOf` function, users can know how much token they own. By calling `totalSupply` function, users can have an overview of the total token supply.

With `approve` function, users can add any smart contracts they want to interact with into the allowance list.

With `transfer` and `transferFrom`, token holders can transfer to any address and withdraw their token from all the contracts that they have approved.

### AMM

I also implemented a simple constant sum auto market maker (AMM). In this AMM, price of tokens are determined by the equation `X + Y = K`, where `X` is the amount of token A in the AMM and `Y` is the amount of token B in the AMM, while `K` is a constant.

With calculation, we can see that when users want to trade from token A to token B tokens, it follows the rule of `dx = dy`, where `dx` is the amount of token A in and `dy` is the amount of token B out.

When users want to add liquidity, the amount of shares to mint follow the rule of `shares_to_mint = (dx + dy) * total_shares_before_mint / (X + Y)`.

When users want to remove liquidity, the amount of shares to burn follow the rule of `dx = shares_to_burn / total_shares * X` and `dy = shares_to_burn / total_shares * Y`.
