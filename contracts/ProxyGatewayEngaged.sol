/*
__This contract acts as the base inheritance contract
*/

pragma solidity >=0.4.0 <0.6.0;

contract ProxyGatewayEngaged {

    // proxy-gateway contract address
    address public PROXY_GATEWAY;

    // only allow setting this address once
    function setProxyGatewayAddress(address proxyGatewayAddr) public returns (bool) {
        // if address is already set - return false
        if(PROXY_GATEWAY != address(0)) {
            return false;
        }
        PROXY_GATEWAY = proxyGatewayAddr;
        return true;
    }

}