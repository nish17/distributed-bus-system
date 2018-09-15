pragma solidity^0.4.24;

contract System{

    event SenderLogger(address);
    event ValueLogger(uint); 

    address private admin;
    uint public count=0;
    uint priceOfTicket = 2;
    
    struct Ticket{
        bytes32  token;
        string  fromPlace;
        string  toPlace;
        uint price;
    }

    constructor() public{
        admin = msg.sender;
        // Ticket storage newTicket;
        count++;
    }

    // modifer checkOwner {
    //     require(admin == msg.sender);
    //     _;
    // }


    function getTicket() public payable returns(Ticket) { 
        /* returns unique ticket token number */
        Ticket storage newTicket = {
            token:keccak256(abi.encodePacked(block.timestamp, block.difficulty,count)),
            fromPlace: 'A',
            toPlace: 'B',
            price: 10
        };
        emit SenderLogger(msg.sender);
        emit ValueLogger(msg.value);
        // return newTicket({token: uint(keccak256(block.difficulty, now, count)), 
        // fromPlace: 'A', 
        // toPlace: "B", 
        // price: 100});

        // newTicket.token = keccak256(abi.encodePacked(block.timestamp, block.difficulty,count));
    }

    // function getTicket() public payable{
    //     /* returns all the details of the ticket including token number in one object*/
    //     require(msg.value > priceOfTicket);

    // }

    function verifyToken() public view returns(bool){
    /* a function to verify token */
        // return 
    }

}