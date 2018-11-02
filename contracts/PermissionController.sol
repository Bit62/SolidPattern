/*
__This contract works only internal and gets called by logical contacts
*/

pragma solidity >=0.4.0 <0.6.0;

import "./ProxyGateway.sol";
import "./ProxyGatewayEngaged.sol";
import "./PermissionDatabase.sol";

contract PermissionController is ProxyGatewayEngaged {

    bytes32 permissionDatabaseContractName = "PermissionDatabase";
    bytes32 restrictedAccessThroughContractName = "PermissionLogic";

    // set an integer value for permission based on coin tags e.g. "ETH"
    function changePermission(address addr, bytes32 tag, uint8 lvl) public returns (bool) {

        // if gateway address exists
        if(PROXY_GATEWAY != address(0)) {
            // allow access only through contract flow
            ProxyGateway(PROXY_GATEWAY).restrictedAccessToContract(restrictedAccessThroughContractName);

            // get permission database address
            address permissionDatabase = ProxyGateway(PROXY_GATEWAY).contracts(permissionDatabaseContractName);

            // change data at database contract
            bool success = PermissionDatabase(permissionDatabase).changePermission(addr, tag, lvl);

            // return success
            return success;
        }

        return false;

    }

    // get permission by coin tag and user address
    function getPermission(address addr, bytes32 tag) public view returns (uint8) {

        // if gateway address exists
        if(PROXY_GATEWAY != address(0)) {
            // allow access only through contract flow
            ProxyGateway(PROXY_GATEWAY).restrictedAccessToContract(restrictedAccessThroughContractName);

            // get permission database address
            address permissionDatabase = ProxyGateway(PROXY_GATEWAY).contracts(permissionDatabaseContractName);

            // get permission of sender address
            uint8 lvl = PermissionDatabase(permissionDatabase).getPermission(addr, tag);

            // return level of address
            return lvl;
        }

        return 0;

    }

}