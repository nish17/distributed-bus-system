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
        /* returns unique ticket token number */
        if(msg.value == 10 ether){
            token = keccak256(abi.encodePacked(block.timestamp, block.difficulty,count));
            emit SenderLogger(msg.sender);
            emit ValueLogger(msg.value);
        }
    }
    function getToken() public view returns(bytes32){
        return token;
    }

}