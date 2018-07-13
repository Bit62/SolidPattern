/*
__This contract shows an example of a controller contract
-
*/

pragma solidity ^0.4.21;

import "./ProxyContract.sol";
import "./CoinETHDatabaseContract.sol";

contract CoinETHController  {

    Proxy proxy;

    constructor(address proxyContract) public {
        proxy = Proxy(proxyContract);
    }

    // function to deposit coin using the connected database contract
    //-> return bool
    function deposit(address coinETHDatabase, address depositAddr, uint depositAmount) public returns (bool) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("CoinETHLogicContact");

        // deposit amount to specific address
        bool success = CoinETHDatabase(coinETHDatabase).deposit(depositAddr, depositAmount);

        // if deposit is not successfully return false
        if(!success) {

            return false;

        }

        return true;

    }

    // function to withdraw a coin using the connected database contract
    //-> return bool
    function withdraw(address coinETHDatabase, address withdrawAddr, uint withdrawAmount) public returns (bool) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("CoinETHLogicContact");

        // withdraw amount to specific address
        bool success = CoinETHDatabase(coinETHDatabase).withdraw(withdrawAddr, withdrawAmount);

        // if withdraw successful - pass ether to the caller
        if(success) {

            return true;

        }

        return false;

    }
}