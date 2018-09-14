pragma solidity^0.4.24;

contract System{

    struct Ticket{
        string token;
        string fromPlace;
        string toPlace;
        uint price;
    }
    address public admin;
    uint public count=0;
    uint priceOfTicket = 2;
    
    constructor() public{
        admin = msg.sender;
        count++;
    }

    function getTicket() public returns(Ticket) { 
        /* returns unique ticket token number */
        return Ticket({token: uint(keccak256(block.difficulty, now, count)), 
        fromPlace: 'A', 
        toPlace: "B", 
        price: 100});
        
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