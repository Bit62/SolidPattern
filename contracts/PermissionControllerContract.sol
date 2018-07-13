/*
__This contract works only internal and gets called by logical contacts
*/

pragma solidity ^0.4.21;

import "./ProxyContract.sol";
import "./PermissionDatabaseContract.sol";

contract PermissionController {

    Proxy proxy;

    constructor(address proxyContract) public {
        proxy = Proxy(proxyContract);
    }

    // set an integer value for permission based on coin tags e.g. "ETH"
    function changePermission(address permissionDatabase, address addr, bytes32 tag, uint8 lvl) public returns (bool) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("PermissionLogic");

        // change data at database contract
        bool success = PermissionDatabase(permissionDatabase).changePermission(addr, tag, lvl);

        // return success
        return success;

    }

    // get permission by coin tag and user address
    function getPermission(address permissionDatabase, address senderAddr, bytes32 tag) public view returns (uint8) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("PermissionLogic");

        // get permission of sender address
        uint8 lvl = PermissionDatabase(permissionDatabase).getPermission(senderAddr, tag);

        // return level of address
        return lvl;

    }

}