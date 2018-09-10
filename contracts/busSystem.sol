pragma solidity^0.4.24;

contract System{

    address public admin;
    uint public count=0;
    uint priceOfTicket = 2;
    constructor() public{
        admin = msg.sender;
        count++;
    }

    function generateTokenNumber() public payable returns(uint) { 
        /* returns ticket token number */
        require(msg.value > priceOfTicket);
        return uint(keccak256(block.difficulty, now, count));
        
    }

    function getTicket() public{
        /* returns all the details of the ticket including token number */
    }

}