pragma solidity ^0.4.24;
contract RouteCreator{
    /* Contains all the routes that are deployed on the RINKEBY NETWORK */
    address[] public deployedRoutes;

    /* This function calls the constructor of Route Contract which will create a new Route. */
    function createRoute(string routeID, uint count, bytes32[] description) public{
        address newRoute = new Route(msg.sender, routeID, count, description);
        deployedRoutes.push(newRoute);
    }
    
    function getDeployedRoutes() public view  returns (address[]) {
        return deployedRoutes;
    }
}

contract Route{
    struct Trip {
        string tripDescription;
        uint256 startDateTime;
        uint amount;
        uint approversCount;
        bool isComplete;
        uint reportedArrivalTimes;
        mapping (uint=> bool) approvers;
        mapping (bytes32 => uint256) arrivalsTime;
    }
    struct Ticket {
        string travelDescription;
        uint amount;
        bool isUsed;
    }

    event ValueLogger (
        uint index
    );
    string public routeID;
    uint public busStopCount;
    bytes32[] public routeDescription;
    address public manager;
    uint tripsCount = 0;
    uint ticketsCount = 0;
    Trip[] public trips;
    Ticket[] public tickets;
    // maps the ticketindex to the commuter
    mapping (uint => address) commuter;
    uint totalAmount;

    /* This modifier/function checks whether the sender is the manager of the contract or not.  */
    modifier restricted(){
        require(msg.sender == manager, "Only Manager is allowed");
        _;
    }
    constructor (address creator, string route, uint count, bytes32[] description) public {
        manager = creator;
        routeID = route;
        busStopCount = count;
        routeDescription = description;
    }    

    /* In the above deployed Routes, this function creates a new trip  also it is restricted only to the manager*/
    function createTrip (string description, uint256 dateTime) public restricted {
        Trip memory newTrip = Trip ({
            tripDescription: description,
            startDateTime: dateTime,
            amount:0,
            approversCount:0,
            isComplete: false,
            reportedArrivalTimes : 0
        });
        trips.push(newTrip);
        tripsCount = tripsCount + 1; 
    }

    /* When the trip ends, commuter may approve the trip. approving request is carried out by approveTrip function */
    function approveTrip(uint tripIndex, uint ticketIndex) public {
        Trip storage trip = trips[tripIndex];
        Ticket storage ticket = tickets[ticketIndex];
        
        // trying to approve trip using a valid ticket
        require (!ticket.isUsed, "Ticket is already used!");
        // ticket for approval must be submitted by the commuter who purchsed the ticket
        require (commuter[ticketIndex] == msg.sender, "Seems like it is someone else's ticket");
        // trip must not be complete 
        require(!trip.isComplete, "Trip must not be complete");
        trip.approversCount++;
        trip.amount = trip.amount + ticket.amount;
        //can not approve other trip using same ticket
        ticket.isUsed = true;
        trip.approvers[ticketIndex] = true;
    }


    /* This function is called when the user gets off the bus and want to complete the trip and 
    the trip can only be completed if the this trip has been approved by almost 80% of the commuters*/
    function completeTrip(uint index) public restricted {
        Trip storage trip = trips[index];
        require(!trip.isComplete, "Tip must not complete");
        //trip should have reported at least 80% arrival times
        require(trip.reportedArrivalTimes >= busStopCount*4/5, "trip should have reported at least 80% arrival times");
        manager.transfer(trip.amount);
        trip.isComplete = true;
        totalAmount = totalAmount + trip.amount;
    }

    /* This is a payable function where the user is required to pay for the ticket. */
    function purchaseTicket(string description) public payable returns (uint) {
        require(msg.value>0, "Please pay for the ticket");
        uint newIndex;
        Ticket memory newTicket = Ticket({
            travelDescription: description,
            amount: msg.value,
            isUsed: false
        });
        newIndex = tickets.length;
        tickets.push(newTicket);
        commuter[newIndex] = msg.sender;
        ticketsCount = ticketsCount + 1;
        emit ValueLogger(newIndex);
        return newIndex;
    }

    function arrival(uint tripIndex, bytes32 busStop, uint256 arrivalTime) public {
        Trip storage trip = trips[tripIndex];
        trip.arrivalsTime[busStop] = arrivalTime;
        trip.reportedArrivalTimes++;
    }

    function getNumberOfTrips() public view returns (uint){
        return tripsCount;
    }

    function getNumberOfTickets() public view returns(uint){
        return ticketsCount;
    }
}
