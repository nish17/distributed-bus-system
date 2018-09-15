pragma solidity^0.4.24;

contract System{

    event SenderLogger(address);
    event ValueLogger(uint); 

    address private admin;
    uint public count=0;
    uint priceOfTicket = 2;
    bytes32 token;
    
    constructor() public{
    /* Whenever the contract is deployed for the first time constructor is called and the address is stored in admin variable */
        admin = msg.sender;
        count++;
    }
    function generateToken() public payable { 
        /* generates unique ticket token number */
        if(msg.value == priceOfTicket){
            token = keccak256(abi.encodePacked(block.timestamp, block.difficulty,count));  /* used to creating a random number */
            emit SenderLogger(msg.sender);      /* Logs sender's address */
            emit ValueLogger(msg.value);        /* Logs the value transferred */    
        }
    }
    function getToken() public view returns(bytes32){
        return token;
    }

}