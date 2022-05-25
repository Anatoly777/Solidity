//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Payments {
    address owner;

    event Paid(address indexed _from, uint _amount, uint _timestamp);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(address _to) {
        require(msg.sender == owner, "you are not an owner");
        require(_to != address(0), "incorrect address!");
        _;
    }

    struct Payment {
        uint amount;
        uint timestamp;
        address from;
        string message;
    }

    struct Balance {
        uint totalPayments;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) public balances;

    // call
    function currentBalance() public view returns(uint){
        return address(this).balance;
    }

    // call
    function getPayment(address _addr, uint _index) public view returns(Payment memory){
        return balances[_addr].payments[_index];
    }

    receive() external payable {
        pay("inside");
    }

    // transaction
    function pay(string memory message) public payable {
        uint paymentNum = balances[msg.sender].totalPayments;
        balances[msg.sender].totalPayments++;
        
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender,
            message
        );

        balances[msg.sender].payments[paymentNum] = newPayment;
        emit Paid(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(address payable _to) external onlyOwner(_to){
        _to.transfer(address(this).balance);
    }
}