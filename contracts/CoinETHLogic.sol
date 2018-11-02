/*
__This contract shows an example of a logical contract
-contracts that includes specific logical stuff of an application
*/

pragma solidity >=0.4.0 <0.6.0;

import "./ProxyGateway.sol";
import "./ProxyGatewayEngaged.sol";
import "./CoinETHController.sol";
import "./PermissionLogic.sol";

contract CoinETHLogic is ProxyGatewayEngaged {

    bytes32 coinETHControllerContractName = "CoinETHController";
    bytes32 permissionLogicContractName = "PermissionLogic";

    bytes32 depositPermissionTag = "deposit_eth";
    bytes32 withdrawPermissionTag = "withdraw_eth";

    // function to deposit coin using the connected database contract
    //-> return bool
    function deposit(address depositAddr) external payable returns (bool) {

        // if gateway address exists
        if(PROXY_GATEWAY != address(0)) {

            // get permission controller contract address
            address permissionLogic = ProxyGateway(PROXY_GATEWAY).contracts(permissionLogicContractName);

            // check permission
            uint8 permission = PermissionLogic(permissionLogic).getPermission(msg.sender, depositPermissionTag);

            // if permission is allowed
            if(permission == 1) {

                // get coin ether controller contract
                address coinETHController = ProxyGateway(PROXY_GATEWAY).contracts("CoinETHController");

                uint depositAmount = msg.value;

                // deposit amount to specific address
                bool success = CoinETHController(coinETHController).deposit(depositAddr, depositAmount);

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
        if(PROXY_GATEWAY != address(0)) {

            // get permission controller contract address
            address permissionLogic = ProxyGateway(PROXY_GATEWAY).contracts(permissionLogicContractName);

            // check permission
            uint8 permission = PermissionLogic(permissionLogic).getPermission(msg.sender, withdrawPermissionTag);

            // if permission is allowed
            if(permission == 1) {

                // get coin ether controller contract
                address coinETHController = ProxyGateway(PROXY_GATEWAY).contracts(coinETHControllerContractName);

                // withdraw amount to specific address
                bool success = CoinETHController(coinETHController).withdraw(withdrawAddr, withdrawAmount);

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