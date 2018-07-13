/*
__This contract stores data of users ether values
-
*/

pragma solidity ^0.4.21;

import "./ProxyContract.sol";

contract CoinETHDatabase {

    Proxy proxy;

    constructor(address proxyContract) public {
        proxy = Proxy(proxyContract);
    }

    // mapping addresses and coin balances
    mapping (address => uint) public balances;

    // function to deposit coins
    function deposit(address depositAddr, uint depositAmount) public returns (bool) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("CoinETHController");

        // add amount to current balance
        balances[depositAddr] += depositAmount;

        return true;

    }

    // function to withdraw coins
    function withdraw(address withdrawAddr, uint withdrawAmount) public returns (bool) {

        // allow access only through contract flow
        proxy.restrictedAccessToContract("CoinETHController");

        // store current balance
        uint currentBalance = balances[withdrawAddr];

        // check if current balance is enough for withdraw request
        if(currentBalance >= withdrawAmount) {

            // remove amount from current balance state
            balances[withdrawAddr] = currentBalance - withdrawAmount;

            return true;

        }

        return false;

    }

}