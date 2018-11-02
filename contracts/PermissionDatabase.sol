/*
__This contract works only internal, stores the permission data and gets called by the permission controller contract
*/

pragma solidity >=0.4.0 <0.6.0;

import "./ProxyGateway.sol";
import "./ProxyGatewayEngaged.sol";

contract PermissionDatabase is ProxyGatewayEngaged {

    bytes32 restrictedAccessThroughContractName = "PermissionController";

    // struct coin permission - e.g. "withdraw_eth" - 1
    struct Permission {
        bytes32 tag;
        uint8 lvl;
    }

    // mapping of permissions and addresses
    mapping (address => Permission[]) permissions;

    // set an integer value for permission based on coin tags e.g. "withdraw_eth"
    function changePermission(address addr, bytes32 tag, uint8 lvl) public returns (bool) {

        // if gateway address exists
        if(PROXY_GATEWAY != address(0)) {
            // allow access only through contract flow
            ProxyGateway(PROXY_GATEWAY).restrictedAccessToContract(restrictedAccessThroughContractName);

            Permission memory taggedPermission;

            taggedPermission.tag = tag;
            taggedPermission.lvl = lvl;

            permissions[addr].push(taggedPermission);

            return true;
        }

        return false;

    }

    // get permission by coin tag and user address
    function getPermission(address addr, bytes32 tag) public view returns (uint8) {

        // if gateway address exists
        if(PROXY_GATEWAY != address(0)) {
            // allow access only through contract flow
            ProxyGateway(PROXY_GATEWAY).restrictedAccessToContract(restrictedAccessThroughContractName);

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

        return 0;

    }
}