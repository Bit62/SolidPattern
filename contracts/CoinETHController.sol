/*
__This contract shows an example of a controller contract
-
*/

pragma solidity >=0.4.0 <0.6.0;

import "./ProxyGateway.sol";
import "./ProxyGatewayEngaged.sol";
import "./CoinETHDatabase.sol";

contract CoinETHController is ProxyGatewayEngaged  {

    bytes32 coinETHDatabaseContractName = "CoinETHDatabase";
    bytes32 restrictedAccessThroughContractName = "CoinETHLogic";

    // function to deposit coin using the connected database contract
    //-> return bool
    function deposit(address depositAddr, uint depositAmount) public returns (bool) {

        // if gateway address exists
        if(PROXY_GATEWAY != address(0)) {
            // allow access only through contract flow
            ProxyGateway(PROXY_GATEWAY).restrictedAccessToContract(restrictedAccessThroughContractName);

            // get coin eth database address
            address coinETHDatabase = ProxyGateway(PROXY_GATEWAY).contracts(coinETHDatabaseContractName);

            // deposit amount to specific address
            bool success = CoinETHDatabase(coinETHDatabase).deposit(depositAddr, depositAmount);

            // if deposit is not successfully return false
            if(!success) {

                return false;

            }

            return true;
        }

        return false;

    }

    // function to withdraw a coin using the connected database contract
    //-> return bool
    function withdraw(address withdrawAddr, uint withdrawAmount) public returns (bool) {

        // if gateway address exists
        if(PROXY_GATEWAY != address(0)) {
            // allow access only through contract flow
            ProxyGateway(PROXY_GATEWAY).restrictedAccessToContract(restrictedAccessThroughContractName);

            // get coin eth database address
            address coinETHDatabase = ProxyGateway(PROXY_GATEWAY).contracts(coinETHDatabaseContractName);

            // withdraw amount to specific address
            bool success = CoinETHDatabase(coinETHDatabase).withdraw(withdrawAddr, withdrawAmount);

            // if withdraw successful - pass ether to the caller
            if(success) {

                return true;

            }

            return false;
        }

        return false;

    }
}