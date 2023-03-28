// SPDX-License-Identifier: MIT
// Implement a constant sum AMM: X + Y = K.
pragma solidity ^0.8.17;

import "./token.sol";

contract AMM {
    KafkaToken public immutable token0;
    KafkaToken public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public total_supply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = KafkaToken(_token0);
        token1 = KafkaToken(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        total_supply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        total_supply -= _amount;
    }

    function _update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(
        address _token_in,
        uint _amount_in
    ) external returns (uint amount_out) {
        require(
            _token_in == address(token0) || _token_in == address(token1),
            "Invalid token"
        );
        require(_amount_in > 0, "amount_in should be greater than 0");

        // Pull in token_in.
        bool is_token0 = (_token_in == address(token0));
        (KafkaToken token_in, KafkaToken token_out) = is_token0
            ? (token0, token1)
            : (token1, token0);

        token_in.transferFrom(msg.sender, address(this), _amount_in);

        // Calculate token_out (include fees), fee 0.3%.
        // dy = dx
        uint amount_in_with_fee = (_amount_in * 997) / 1000;
        amount_out = amount_in_with_fee;

        // Transfer token_out to msg.sender.
        token_out.transfer(msg.sender, amount_out);
        // Update the reserves.
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function addLiquidity(
        uint _amount0,
        uint _amount1
    ) external returns (uint shares) {
        // Pull in token0 and token1.
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);

        require(
            _amount0 > 0 && _amount1 > 0,
            "amount0 or amount1 should be greater than 0"
        );

        // Mint shares.
        // f(x, y) = value of liquidity = x + y
        // s = (dx + dy) * T / (x + y)
        if (total_supply == 0) {
            shares = _amount0 + _amount1;
        } else {
            shares =
                ((_amount0 + _amount1) * total_supply) /
                (reserve0 + reserve1);
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        // Update reserves.
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function removeLiquidity(
        uint _shares
    ) external returns (uint amount0, uint amount1) {
        // Calculate amount0 and amount1 to withdraw.
        // dx = s / T * x
        // dy = s / T * y
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / total_supply;
        amount1 = (_shares * bal1) / total_supply;
        require(
            amount0 > 0 && amount1 > 0,
            "amount0 or amount1 should be greater than 0"
        );

        // Burn shares.
        _burn(msg.sender, _shares);
        // Update reserves.
        _update(bal0 - amount0, bal1 - amount1);

        // Transfer tokens to msg.sender.
        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }
}
