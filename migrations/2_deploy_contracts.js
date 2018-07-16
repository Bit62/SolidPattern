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

//var MathService = artifacts.require("./MathServiceContract.sol"); // Deployed as an example - not used in this example

var ProxyGateway = artifacts.require("./ProxyGatewayContract.sol"); // Deployed as the main ecosystem contract
var ProxyGatewayEngaged = artifacts.require("./ProxyGatewayEngagedContract.sol"); // Deployed with the proxy gateway contract address as constructor param

var CoinETHController = artifacts.require("./CoinETHControllerContract.sol"); // Deployed and afterwards registered at gateway contract
var CoinETHDatabase = artifacts.require("./CoinETHDatabaseContract.sol"); // Deployed and afterwards registered at gateway contract
var CoinETHLogic = artifacts.require("./CoinETHLogicContract.sol"); // Deployed and afterwards registered at gateway contract

var PermissionController = artifacts.require("./PermissionControllerContract.sol"); // Deployed and afterwards registered at gateway contract
var PermissionDatabase = artifacts.require("./PermissionDatabaseContract.sol"); // Deployed and afterwards registered at gateway contract
var PermissionLogic = artifacts.require("./PermissionLogicContract.sol"); // Deployed and afterwards registered at gateway contract


module.exports = function(deployer) {
    //deployer.deploy(MathService);
    deployer.deploy(ProxyGateway);
    deployer.deploy(ProxyGatewayEngaged);

    deployer.deploy(CoinETHDatabase);
    deployer.link(ProxyGateway, CoinETHDatabase);
    deployer.link(ProxyGatewayEngaged, CoinETHDatabase);

    deployer.deploy(CoinETHController);
    deployer.link(ProxyGateway, CoinETHController);
    deployer.link(ProxyGatewayEngaged, CoinETHController);
    deployer.link(CoinETHDatabase, CoinETHController);

    deployer.deploy(CoinETHLogic);
    deployer.link(ProxyGateway, CoinETHLogic);
    deployer.link(ProxyGatewayEngaged, CoinETHLogic);
    deployer.link(CoinETHController, CoinETHLogic);

    deployer.deploy(PermissionDatabase);
    deployer.link(ProxyGateway, PermissionDatabase);
    deployer.link(ProxyGatewayEngaged, PermissionDatabase);

    deployer.deploy(PermissionController);
    deployer.link(ProxyGateway, PermissionController);
    deployer.link(ProxyGatewayEngaged, PermissionController);
    deployer.link(PermissionDatabase, PermissionController);

    deployer.deploy(PermissionLogic);
    deployer.link(ProxyGateway, PermissionLogic);
    deployer.link(ProxyGatewayEngaged, PermissionLogic);
    deployer.link(PermissionController, PermissionLogic);

};