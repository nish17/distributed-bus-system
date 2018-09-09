pragma solidity^0.4.24;

contract System{

    address public admin;

    constructor() public{
        admin = msg.sender;
    }

    function getTicket() public view { 
    }
}