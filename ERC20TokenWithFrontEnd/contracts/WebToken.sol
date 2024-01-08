// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Webtoken {
    bytes public name;
    bytes public symbol;
    uint8 public decimals;
    uint256 private initialSupply;
    address private owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

   

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier AdminAllowance(address _TokenOwner, address _TokenAdmin) {
        require(allowed[_TokenOwner][_TokenAdmin] > 0, "No Allowance for admin");
        _;
    }

    constructor() {
        name = "WebToken";
        symbol = "WebT";
        decimals = 18;
        initialSupply = 1000;
        owner = msg.sender;
        balances[owner] = initialSupply;
    }

    function totalSupply() public view returns (uint) {
        return initialSupply;
    }

    function balanceOf(address CheckBalance) public view returns (uint) {
        return balances[CheckBalance];
    }

    function transfer(address _from,uint _Qty, address _to) public {
        require(balances[_from] >= _Qty, "Insufficient Balance");
        balances[_from] -= _Qty;
        balances[_to] += _Qty;
        emit Transfer(_from, _to, _Qty);
    }

    function approve(address _owner, address _TokenAdmin, uint _Qty) public {
        require(balances[_owner] >= _Qty, "Insufficient Token");
        allowed[_owner][_TokenAdmin] = _Qty;
        emit Approval(_owner, _TokenAdmin, _Qty);
    }

    function allowance(address _TokenAdmin) public view AdminAllowance(msg.sender, _TokenAdmin) returns (uint) {
        return allowed[msg.sender][_TokenAdmin];
    }

    function transferFrom(address _owner, address _admin, address _to, uint _Qty) public AdminAllowance(msg.sender, _admin) {
        require(balances[_owner] >= _Qty, "Insufficient Balance");
        require(allowed[_owner][_admin] >= _Qty, "Insufficient Allowance");
        allowed[_owner][_admin] -= _Qty;
        balances[_owner] -= _Qty;
        balances[_to] += _Qty;
        emit Transfer(_owner, _to, _Qty);
    }
}
