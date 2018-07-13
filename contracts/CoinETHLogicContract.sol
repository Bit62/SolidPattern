/*
__This contract shows an example of a logical contract
-contracts that includes specific logical stuff of an application
*/

pragma solidity ^0.4.21;

import "./ProxyContract.sol";
import "./GatewayContract.sol";
import "./PermissionLogicContract.sol";
import "./CoinETHControllerContract.sol";

contract CoinETHLogic {

    Proxy proxy;

    constructor(address proxyContract) public {
        proxy = Proxy(proxyContract);
    }

    // function to deposit coin using the connected database contract
    //-> return bool
    function deposit(address depositAddr) external payable returns (bool) {

        // if gateway address exists
        if(proxy.GATEWAY() != 0x0) {

            // get permission controller contract address
            address permissionLogic = Gateway(proxy.GATEWAY()).contracts("PermissionLogic");

            // check permission
            uint8 permission = PermissionLogic(permissionLogic).getPermission(msg.sender, "deposit_eth");

            // if permission is allowed
            if(permission == 1) {

                // get coin ether controller contract
                address coinETHController = Gateway(proxy.GATEWAY()).contracts("CoinETHController");

                // get coin ether database contract
                address coinETHDatabase = Gateway(proxy.GATEWAY()).contracts("CoinETHDatabase");

                uint depositAmount = msg.value;
                // deposit amount to specific address
                bool success = CoinETHController(coinETHController).deposit(coinETHDatabase, depositAddr, depositAmount);

                // if deposit is not successfully - return value to sender
                if(!success) {

                    msg.sender.transfer(msg.value);

                    return false;

                }

            }

            return false;

        }

        return false;

    }

    // function to withdraw a coin using the connected database contract
    //-> return bool
    function withdraw(address withdrawAddr, uint withdrawAmount) external returns (bool) {

        // if gateway address exists
        if(proxy.GATEWAY() != 0x0) {

            // get permission controller contract address
            address permissionLogic = Gateway(proxy.GATEWAY()).contracts("PermissionLogic");

            // check permission
            uint8 permission = PermissionLogic(permissionLogic).getPermission(msg.sender, "withdraw_eth");

            // if permission is allowed
            if(permission == 1) {

                // get coin ether controller contract
                address coinETHController = Gateway(proxy.GATEWAY()).contracts("CoinETHController");

                // get coin ether database contract
                address coinETHDatabase = Gateway(proxy.GATEWAY()).contracts("CoinETHDatabase");

                // withdraw amount to specific address
                bool success = CoinETHController(coinETHController).withdraw(coinETHDatabase, withdrawAddr, withdrawAmount);

                // if withdraw successful - pass ether to the caller
                if(success) {

                    withdrawAddr.transfer(withdrawAmount);

                    return true;

                }

            }

            return false;

        }

        return false;

    }

}