module.exports = {
    networks: {
        testrpc: { //testrpc
            host: "127.0.0.1",
            port: 8545,
            network_id: "*",
            gas: 0
        },
        development: { //ganache
            host: "127.0.0.1",
            port: 7545,
            network_id: "*",
            gas: 0
        }
    }
};