/*
__This contract stores 21 owner addresses and allows to vote for changes.
 Contracts:
  -
*/
pragma solidity ^0.4.21;

import "./GatewayContract.sol";
import "./MathServiceContract.sol";

contract Proxy {

    // count owner - so we know what is more or equal of 60 percent and there are not more then 21 owners
    uint8 private countOwner;

    // proxy and gateway contract address
    address public PROXY;
    address public GATEWAY;

    // struct request
    struct RequestForChange {
        uint256 timeStamp; // the time this request was generated so it is only available for a certain time
        bytes32 requestType; // the name of action which should be called if enough
        bytes32 involvedIdentifier; // the name of action which should be called if enough
        address involvedAddress; // the address that needs to get involved into the system
        address creatorAddress; // the address who created this request
        uint8 posVotes; // count all positive votes
        uint8 negVotes; // count all negative votes
        mapping (address => bool) voters;
    }

    // mapping owners
    mapping (address => bool) private owners;

    // mapping requests -> a owner is only allowed to create one request at a time!
    mapping (address => RequestForChange) private requests;

    // mapping of contract managers
    mapping (address => bool) public managers;

    // constructor set first owner
    constructor() internal {
        PROXY = address(this);
        owners[msg.sender] = true;
        countOwner += 1;
    }

    // modifier restrict access to - one of the owners
    modifier restrictedAccess {
        if (!owners[msg.sender]) revert();
        _;
    }

    // function restrict access to - specific contract address
    function restrictedAccessToContract(bytes32 contractName) public view {
        (address contractAddr, bool contractExists) = Gateway(GATEWAY).getContract(contractName);
        if(!contractExists || msg.sender != contractAddr) revert();
    }

    // modifier not allowing more then 21 owners
    modifier maxOwners {
        if (countOwner <= 20) _;
    }

    // create request for critical changes
    // this could be improved by adding a function that forbids similar requests from the same owner between a certain time
    function newRequest(bytes32 requestType, address involvedAddress) restrictedAccess external returns (bool) {

        RequestForChange storage newRequestStruct = requests[msg.sender];

        newRequestStruct.timeStamp = block.timestamp;
        newRequestStruct.requestType = requestType;
        newRequestStruct.involvedAddress = involvedAddress;
        newRequestStruct.creatorAddress = msg.sender;
        newRequestStruct.posVotes += 1;
        newRequestStruct.negVotes = 0;
        newRequestStruct.voters[msg.sender] = true;

        requests[msg.sender] = newRequestStruct;
    }

    // vote for specific request
    function voteForRequest(address addr, bool vote) restrictedAccess external returns (bool) {

        RequestForChange storage thisRequest = requests[addr];

        // if owner has already voted
        if(!thisRequest.voters[msg.sender]) {
            return false;
        }

        // if too much time is passed > 30 days is over
        if(block.timestamp > (thisRequest.timeStamp + 30 days)) {
            return false;
        }

        // increase vote
        if(vote) {
            thisRequest.posVotes += 1;
        } else {
            thisRequest.negVotes += 1;
        }

        // add voter to mapping
        thisRequest.voters[msg.sender] = vote;

        return true;

    }

    // check votes - if more than majority - make actual changes - no time limits because changes need to go quick
    function checkVotings(address addr) restrictedAccess external returns (bool) {

        RequestForChange storage thisRequest = requests[addr];

        // get math service contract address
        address mathService = Gateway(GATEWAY).contracts("MathService");
        uint8 majority = MathService(mathService).calculateOwnerMajority(countOwner);

        // if the majority says no - remove request
        if(thisRequest.negVotes > majority) {
            delete requests[addr];
        }

        // if the majority says yes - run change
        bool success = false;
        if(thisRequest.posVotes > majority) {

            if(thisRequest.requestType == keccak256("addOwner")) {
                success = addOwner(thisRequest.involvedAddress);
            }

            if(thisRequest.requestType == keccak256("removeOwner")) {
                success = removeOwner(thisRequest.involvedAddress);
            }

            if(thisRequest.requestType == keccak256("changeGatewayContract")) {
                success = changeGatewayContract(thisRequest.involvedAddress);
            }

            if(thisRequest.requestType == keccak256("selfDestruct")) {
                kill(thisRequest.involvedAddress);
            }

            if(thisRequest.requestType == keccak256("addContract")) {
                success = Gateway(GATEWAY).addContract(thisRequest.involvedIdentifier ,thisRequest.involvedAddress);
            }

            if(thisRequest.requestType == keccak256("removeContract")) {
                success = Gateway(GATEWAY).removeContract(thisRequest.involvedIdentifier);
            }

            if(thisRequest.requestType == keccak256("addManager")) {
                success = addManager(thisRequest.involvedAddress);
            }

            if(thisRequest.requestType == keccak256("removeManager")) {
                success = removeManager(thisRequest.involvedAddress);
            }

        }

        if(success) {
            return true;
        }

        return false;

    }

    // add manager
    function addManager(address addr) internal returns (bool) {

        // check if user already exists
        if(managers[addr]) {
            return false;
        }

        managers[addr] = true;

        return true;

    }

    // remove manager
    function removeManager(address addr) internal returns (bool) {

        // check if user exists
        if(!managers[addr]) {
            return false;
        }

        delete managers[addr];

        return true;

    }

    // change gateway contract
    function changeGatewayContract(address addr) internal returns (bool) {

        GATEWAY = Gateway(addr);

    }

    // add new owner address
    function addOwner(address addr) maxOwners internal returns (bool) {

        // check if user already exists
        if(owners[addr]) {
            return false;
        }

        owners[addr] = true;
        countOwner += 1;

        return true;
    }

    // remove owner address
    function removeOwner(address addr) internal returns (bool) {

        // check if user exists
        if(!owners[addr]) {
            return false;
        }

        delete owners[addr];
        countOwner -= 1;

        return true;
    }

    // kill this contract
    function kill(address sendFundsTo) internal {

        // self destruct function
        selfdestruct(sendFundsTo);

    }

}