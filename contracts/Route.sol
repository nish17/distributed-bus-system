/* to do
address the error: un implemented  feature : nested arrays not yet implemented

Evaluation: read / write delay wrt to the number of commuters purchasing tickets
and number of ongoing trips will be assessed using the rinkby testnet


route description will be the list of bus-stops
every trip will report its arrival time at every bus-stop

if a trip has reported its arrival at more than 80% of the bus-stops, it will  be
eligible for the completion

this will take care of the issue when the bus-operator does not complete the trip
*/

pragma solidity ^0.4.24;
contract RouteCreator{
    address[] public deployedRoutes;
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
    Trip[] public trips;
    Ticket[] public tickets;
    // maps the ticketindex to the commuter
    mapping (uint => address) commuter;
    uint totalAmount;

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
    }
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
    function completeTrip(uint index) public restricted {
        Trip storage trip = trips[index];
        require(!trip.isComplete, "Tip must not complete");
        //trip should have reported at least 80% arrival times
        require(trip.reportedArrivalTimes >= busStopCount*4/5, "trip should have reported at least 80% arrival times");
        manager.transfer(trip.amount);
        trip.isComplete = true;
        totalAmount = totalAmount + trip.amount;
    }
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
        emit ValueLogger(newIndex);
        return newIndex;
    }
    function arrival(uint tripIndex, bytes32 busStop, uint256 arrivalTime) public {
        Trip storage trip = trips[tripIndex];
        trip.arrivalsTime[busStop] = arrivalTime;
        trip.reportedArrivalTimes++;
    }
}
