/*
* How to deploy:
*
* 1: deploy - MathService.sol
* 2: deploy - GatewayContract.sol - add MathService Address to Constructor
* 3: deploy - ProxyContract.sol - add Gateway Address to Constructor - or use proxy contract to set the gateway contract address
* 5: deploy - all other contracts and add it too with der contract name to the gateway contract
* 6: use proxy to vote for adding, removing owner and manager, as well es new contracts or changes
*
* */

var MathService = artifacts.require("./MathServiceContract.sol"); // Deployed and afterwards registered at gateway contract - or add it directly into the constructor

var Gateway = artifacts.require("./GatewayContract.sol"); // Deployed and afterwards registered at gateway contract
var Proxy = artifacts.require("./ProxyContract.sol"); // Deployed and afterwards registered at gateway contract

var CoinETHController = artifacts.require("./CoinETHControllerContract.sol"); // Deployed and afterwards registered at gateway contract
var CoinETHDatabase = artifacts.require("./CoinETHDatabaseContract.sol"); // Deployed and afterwards registered at gateway contract
var CoinETHLogic = artifacts.require("./CoinETHLogicContract.sol"); // Deployed and afterwards registered at gateway contract

var PermissionController = artifacts.require("./PermissionControllerContract.sol"); // Deployed and afterwards registered at gateway contract
var PermissionDatabase = artifacts.require("./PermissionDatabaseContract.sol"); // Deployed and afterwards registered at gateway contract
var PermissionLogic = artifacts.require("./PermissionLogicContract.sol"); // Deployed and afterwards registered at gateway contract


module.exports = function(deployer) {
    deployer.deploy(MathService);
    deployer.deploy(Gateway);
    deployer.deploy(Proxy);
    deployer.link(MathService, Proxy);
    deployer.link(Gateway, Proxy);
    deployer.link(Proxy, Gateway);
    deployer.deploy(CoinETHLogic);
    deployer.link(Proxy, CoinETHLogic);
    deployer.link(Gateway, CoinETHLogic);
    deployer.link(PermissionLogic, CoinETHLogic);
    deployer.deploy(CoinETHController);
    deployer.link(CoinETHController, CoinETHLogic);
    deployer.deploy(CoinETHDatabase);
    deployer.link(CoinETHDatabase, CoinETHController);
    deployer.deploy(PermissionLogic);
    deployer.link(Proxy, PermissionLogic);
    deployer.link(Gateway, PermissionLogic);
    deployer.deploy(PermissionController);
    deployer.deploy(PermissionDatabase);
    deployer.link(PermissionDatabase, PermissionController);
    deployer.link(PermissionController, PermissionLogic);
};