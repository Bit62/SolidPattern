/*
__This contract has some public functions to change permissions
- includes proxy to access the gateway and manager permissions
- contracts that includes specific logical stuff of an application
*/

pragma solidity >=0.4.0 <0.6.0;

import "./ProxyGateway.sol";
import "./ProxyGatewayEngaged.sol";
import "./PermissionController.sol";

contract PermissionLogic is ProxyGatewayEngaged {

    bytes32 permissionControllerContractName = "PermissionController";

    // set an integer value for permission based on coin tags e.g. "deposit_eth", "withdraw_eth"
    function changePermission(address addr, bytes32 tag, uint8 lvl) external returns (bool) {

        // if gateway is set and sender address is manager
        if(PROXY_GATEWAY != address(0) && ProxyGateway(PROXY_GATEWAY).managers(msg.sender)) {

            // get permission controller address
            address permissionController = ProxyGateway(PROXY_GATEWAY).contracts(permissionControllerContractName);

            // change permission
            bool success = PermissionController(permissionController).changePermission(addr, tag, lvl);

            // return success
            return success;
        }

        // else return false
        return false;

    }

    // get permission by coin tag and user address
    function getPermission(address addr, bytes32 tag) public view returns (uint8) {

        // if gateway is set
        if(PROXY_GATEWAY != address(0)) {

            // get permission controller address
            address permissionController = ProxyGateway(PROXY_GATEWAY).contracts(permissionControllerContractName);

            // get permission of sender address
            uint8 lvl = PermissionController(permissionController).getPermission(addr, tag);

            // return level of address
            return lvl;

        }

        // else return 0
        return 0;
    }

}