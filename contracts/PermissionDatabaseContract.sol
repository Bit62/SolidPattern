/*
__This contract works only internal, stores the permission data and gets called by the permission controller contract
*/

pragma solidity ^0.4.21;

import "./ProxyContract.sol";

contract PermissionDatabase {

    Proxy proxy;

    constructor(address proxyContract) public {
        proxy = Proxy(proxyContract);
    }

    // struct coin permission - e.g. "withdraw_eth" - 1
    struct Permission {
        bytes32 tag;
        uint8 lvl;
    }

    // mapping of permissions and addresses
    mapping (address => Permission[]) permissions;

    // set an integer value for permission based on coin tags e.g. "withdraw_eth"
    function changePermission(address addr, bytes32 tag, uint8 lvl) public returns (bool) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("PermissionController");

        Permission memory taggedPermission;

        taggedPermission.tag = tag;
        taggedPermission.lvl = lvl;

        permissions[addr].push(taggedPermission);

        return true;

    }

    // get permission by coin tag and user address
    function getPermission(address addr, bytes32 tag) public view returns (uint8) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("PermissionController");

        Permission[] storage taggedPermissionsArray = permissions[addr];

        uint length = taggedPermissionsArray.length;

        for(uint i = 0; i < length; i++) {

            Permission memory taggedPermission;

            taggedPermission = taggedPermissionsArray[i];

            if(taggedPermission.tag == tag) {

                return taggedPermission.lvl;

            }
        }

        return 0;

    }
}