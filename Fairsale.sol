pragma solidity 0.4.4;

contract Fairsale {
    address public owner;
    uint public finalblock;
    uint public adminRefundBlock;
    uint public target;
    uint public raised;
    bool funded;
    mapping(address => uint) public balances;
    mapping(address => bool) public refunded;

    function Fairsale(uint _blocks, uint _target) {
        owner = msg.sender;
        finalblock = block.number + _blocks;
        adminRefundBlock = finalblock + 80000; //about 2 weeks
        target = _target;
    }

    function _deposit() private {
        if (block.number > finalblock) throw;
        balances[msg.sender] += msg.value;
        raised += msg.value;
    }

    function deposit() payable {
        _deposit();
    }

    function() payable {
        _deposit();
    }
    
    function safebalance(uint bal) returns (uint) {
        if (bal > this.balance) {
            return this.balance;
        } else {
            return bal;
        }
    }
    
    function refund(address recipient) private {
        if (refunded[recipient]) throw;
        uint deposit = balances[recipient];
        uint keep = (deposit * target) / raised;
        uint refund = safebalance(deposit - keep);

        refunded[recipient] = true;
        if (!recipient.call.value(refund)()) throw;
    }
    
    function adminRefund(address recipient) {
        if (msg.sender != owner) throw;
        if (block.number <= adminRefundBlock) throw;
        refund(recipient);
    }

    function withdrawRefund() {
        if (block.number <= finalblock) throw;
        if (raised <= target) throw;
        refund(msg.sender);
    }

    function fundOwner() {
        if (block.number <= finalblock) throw;
        if (funded) throw;
        funded = true;
        if (raised < target) {
            if (!owner.call.value(safebalance(raised))()) throw;
        } else {
            if (!owner.call.value(safebalance(target))()) throw;
        }
    }
}
