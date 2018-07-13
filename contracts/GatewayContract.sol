/*
__This contract stores all contract addresses which are used in this application
 Contracts:
  -add contract
  -remove contract
  -get contract
*/

pragma solidity ^0.4.21;

import "./ProxyContract.sol";

contract Gateway {

    Proxy proxy;

    constructor(address proxyContract) public {
        proxy = Proxy(proxyContract);
    }

    // mapping contracts
    mapping(bytes32 => address) public contracts;

    // add a new contract
    function addContract(bytes32 name, address addr) public returns (bool) {

        // allowed only from proxy contract
        if(msg.sender != proxy.PROXY()) {
            revert();
        }

        // check if contract exists
        if(contracts[name] != 0x0) {
            return false;
        }

        contracts[name] = addr;

        return true;
    }

    // remove a contract
    function removeContract(bytes32 name) public returns (bool) {

        // allowed only from proxy contract
        if(msg.sender != proxy.PROXY()) {
            revert();
        }

        // check if contract exists
        if(contracts[name] == 0x0) {
            return false;
        }

        contracts[name] = 0x0;

        return true;
    }

    // function to get a contract address by name
    function getContract(bytes32 contractName) public constant returns (address, bool) {

        address contractAddress = contracts[contractName];

        bool contractExists = true;

        if(contractAddress == 0x0) {
            contractExists = false;
        }

        return (contractAddress, contractExists);
    }


}