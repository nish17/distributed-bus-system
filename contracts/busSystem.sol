pragma solidity^0.4.24;

contract System{

    event SenderLogger(address);
    event ValueLogger(uint); 

    address private admin;
    uint public count=0;
    uint priceOfTicket = 2;
    bytes32  token;
    
    constructor() public{
        admin = msg.sender;
        count++;
    }

    // modifer checkOwner {
    //     require(admin == msg.sender);
    //     _;
    // }
    function getToken() public payable returns(bytes32) { 
        /* returns unique ticket token number */
        if(msg.value == 10 ether){
            token = keccak256(abi.encodePacked(block.timestamp, block.difficulty,count));
            emit SenderLogger(msg.sender);
            emit ValueLogger(msg.value);
            return token;
        }
    }

    // function getTicket() public payable{
    //     /* returns all the details of the ticket including token number in one object*/
    //     require(msg.value > priceOfTicket);

    // }

    // function verifyToken() public view returns(bool){
    // /* a function to verify token */
    //     // return 
    // }

}