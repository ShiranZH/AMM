// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract KafkaToken {
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 _totalSupply = 500;
    address public owner;

    constructor() {
        owner = msg.sender;
        balances[owner] = _totalSupply;
    }

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    function mint(uint _amount) public returns (bool success) {
        _totalSupply += _amount;
        balances[msg.sender] += _amount;
        return true;
    }

    function totalSupply() public view returns (uint theTotalSupply) {
        theTotalSupply = _totalSupply;
        return theTotalSupply;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }

    function approve(
        address _spender,
        uint _amount
    ) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transfer(address _to, uint _amount) public returns (bool success) {
        if (balances[msg.sender] >= _amount) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;

            emit Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint _amount
    ) public returns (bool success) {
        if (
            balances[_from] >= _amount &&
            allowed[_from][msg.sender] >= _amount &&
            _amount > 0 &&
            balances[_to] + _amount > balances[_to]
        ) {
            balances[_from] -= _amount;
            balances[_to] += _amount;
            emit Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }
}
