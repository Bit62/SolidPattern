/*
__This contract acts as the base inheritance contract
*/

pragma solidity ^0.4.21;

contract ProxyGatewayEngaged {

    // proxy-gateway contract address
    address public PROXY_GATEWAY;

    constructor(address proxyGatewayAddr) internal {
        PROXY_GATEWAY = proxyGatewayAddr;
    }

    function setProxyGatewayAddress(address proxyGatewayAddr) public returns (bool) {
        if(PROXY_GATEWAY != 0x0 && msg.sender != PROXY_GATEWAY) {
            return false;
        }
        PROXY_GATEWAY = proxyGatewayAddr;
        return true;
    }

}