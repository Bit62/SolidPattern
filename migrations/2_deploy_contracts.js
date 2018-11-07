/**
 * Contracts:
 * ProxyGateway (includes: ProxyGatewayEngaged)
 * ProxyGatewayEngaged
 * PermissionLogic (includes: ProxyGateway, ProxyGatewayEngaged, PermissionController)
 * PermissionController (includes: ProxyGateway, ProxyGatewayEngaged, PermissionDatabase, PermissionLogic)
 * PermissionDatabase (includes: ProxyGateway, ProxyGatewayEngaged)
 * CoinETHLogic (includes: ProxyGateway, ProxyGatewayEngaged, CoinETHController, PermissionLogic)
 * CoinETHController (includes: ProxyGateway, ProxyGatewayEngaged, CoinETHDatabase)
 * CoinETHDatabase (includes: ProxyGateway, ProxyGatewayEngaged)
 */

/**
 * Deployment Flow:
 * 1: ProxyGateway
 * 2: ProxyGatewayEngaged
 * 3: ProxyGatewayEngaged - Set ProxyGateway address
 * 4: Deploy Permission Contracts
 * 5: Deploy CoinETH Contracts
 */


/**
 * Set variables for contracts we'd like to interact with
 */
var ProxyGateway = artifacts.require("./ProxyGateway.sol"); // Deployed as the main ecosystem contract
var ProxyGatewayEngaged = artifacts.require("./ProxyGatewayEngaged.sol"); // Deployed with the proxy gateway contract address as constructor param

var PermissionController = artifacts.require("./PermissionController.sol"); // Deployed and afterwards registered at gateway contract
var PermissionDatabase = artifacts.require("./PermissionDatabase.sol"); // Deployed and afterwards registered at gateway contract
var PermissionLogic = artifacts.require("./PermissionLogic.sol"); // Deployed and afterwards registered at gateway contract

var CoinETHController = artifacts.require("./CoinETHController.sol"); // Deployed and afterwards registered at gateway contract
var CoinETHDatabase = artifacts.require("./CoinETHDatabase.sol"); // Deployed and afterwards registered at gateway contract
var CoinETHLogic = artifacts.require("./CoinETHLogic.sol"); // Deployed and afterwards registered at gateway contract

/**
 * Set deployment execution order
 */
module.exports = function(deployer) {
    deployer.deploy(ProxyGateway);

    deployer.deploy(ProxyGatewayEngaged).then(function() {
        ProxyGatewayEngaged.setProxyGatewayAddress(ProxyGateway.address);
    });

    deployer.deploy(PermissionLogic);
    deployer.deploy(PermissionController);
    deployer.deploy(PermissionDatabase);

    deployer.deploy(CoinETHLogic);
    deployer.deploy(CoinETHController);
    deployer.deploy(CoinETHDatabase);
};