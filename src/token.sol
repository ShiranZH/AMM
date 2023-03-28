// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract KafkaToken is IERC20 {
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 _total_supply = 500;
    address public owner;

    constructor() {
        owner = msg.sender;
        balances[owner] = _total_supply;
    }

    function mint(uint _amount) public returns (bool success) {
        _total_supply += _amount;
        balances[msg.sender] += _amount;
        return true;
    }

    function totalSupply() public view returns (uint total_supply) {
        total_supply = _total_supply;
        return total_supply;
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
        require(
            _amount <= balances[msg.sender],
            "amount exceeds account balances"
        );
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint _amount
    ) public returns (bool success) {
        require(_amount > 0, "invalid amount");
        require(_amount <= balances[_from], "amount exceeds account balances");
        require(
            _amount <= allowed[_from][msg.sender],
            "amount exceeds allowance"
        );
        balances[_from] -= _amount;
        allowed[_from][msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }
}
