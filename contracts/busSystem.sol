pragma solidity^0.4.24;

contract System{

    address public admin;
    uint public count=0;
    uint priceOfTicket = 2;
    constructor() public{
        admin = msg.sender;
        count++;
    }

    function generateTokenNumber() public returns(uint) { 
        /* returns unique ticket token number */
        return uint(keccak256(block.difficulty, now, count));
        
    }

    function getTicket() public payable{
        /* returns all the details of the ticket including token number in one object*/
        require(msg.value > priceOfTicket);

    }

    function verifyToken() public view returns(bool){
    /* a function to verify token */
        // return 
    }

}