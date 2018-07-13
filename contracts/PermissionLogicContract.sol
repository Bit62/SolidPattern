/*
__This contract has some public functions to change permissions
- includes proxy to access the gateway and manager permissions
- contracts that includes specific logical stuff of an application
*/

pragma solidity ^0.4.21;

import "./ProxyContract.sol";
import "./GatewayContract.sol";
import "./PermissionControllerContract.sol";

contract PermissionLogic {

    Proxy proxy;

    constructor(address proxyContract) public {
        proxy = Proxy(proxyContract);
    }

    // set an integer value for permission based on coin tags e.g. "deposit_eth", "withdraw_eth"
    function changePermission(address addr, bytes32 tag, uint8 lvl) external returns (bool) {

        // if gateway is set and sender address is manager
        if(proxy.GATEWAY() != 0x0 && proxy.managers(msg.sender)) {

            // get permission controller address
            address permissionController = Gateway(proxy.GATEWAY()).contracts("PermissionController");

            // get permission database contract address
            address permissionDatabase = Gateway(proxy.GATEWAY()).contracts("PermissionDatabase");

            // change permission
            bool success = PermissionController(permissionController).changePermission(permissionDatabase, addr, tag, lvl);

            // return success
            return success;
        }

        // else return false
        return false;

    }

    // get permission by coin tag and user address
    function getPermission(address senderAddr, bytes32 tag) public view returns (uint8) {

        // if gateway is set
        if(proxy.GATEWAY() != 0x0) {

            // get permission controller address
            address permissionController = Gateway(proxy.GATEWAY()).contracts("PermissionController");

            // get permission database contract address
            address permissionDatabase = Gateway(proxy.GATEWAY()).contracts("PermissionDatabase");

            // get permission of sender address
            uint8 lvl = PermissionController(permissionController).getPermission(permissionDatabase, senderAddr, tag);

            // return level of address
            return lvl;

        }

        // else return 0
        return 0;
    }

}