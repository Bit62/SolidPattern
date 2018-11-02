# [SolidPattern](http://solidpattern.academy/)

Building applications on Ethereum Blockchain introduces some new challenges. The Solidity Contract Pattern is designed to help developers minimize these hurdles and build smart and scalable backends for ecosystem applications. They do not have a logical pattern to wait for applications on the Ethereum Blockchain, so they can be used in the long run. With a clearly defined pattern, we expect a more efficient implementation of decentralized applications on the Ethereum Blockchain.

Project Concept High Level View:

![SolidPattern High Level View](https://solidpattern.academy/assets/solidity_pattern.jpg)

The full project description can be found at [solidpattern.academy](https://solidpattern.academy/).

Note: This project should help you building bigger scalable blockchain solutions by using this concept and the basic contracts code. There is no GUI or a playground yet - feel free to add so.

This project uses truffle for development and testing.

Requirements:
- Truffle Framework and Local Ethereum Network like TestRPC or something similar e.g. Ganache
- Or just use Remix Online Compiler

Truffle can be installed as a global npm package:
```
npm i -g truffle
```

Install TestRPC or Download Ganache
```
npm i -g ethereumjs-testrpc
```

All involved smart contracts can be compiled via the truffle command `truffle compile`. The result of the compilation can be found inside the `build` directory.

Run truffle migration like truffle migrate including your choice of local blockchain eg. `truffle migrate --network testrpc`. You can edit this setting inside the truffle.js file.

Each Contract Function can accessed via the `truffle console` using the deployed function like `ContractName.deployed()`

For further information about working with Truffle read the [Truffle Framework Docs](http://truffleframework.com/docs).

#### Recommended alternative:

Because of the rapid development in this area, I recommend using simply the remix online compiler because of its 
up-to-dateness and well-developed debugging process.

The remix online compiler is a part of the ethereum foundation itself and can be found unter [remix.ethereum.org](https://remix.ethereum.org/).

##### Deployment flow on Remix:
- Deploy Proxy Gateway Contract
- Deploy Proxy Gateway Engaged (run setProxyGateway - pass the proxy gateway address)
- Deploy All other Contracts
- Play with the Functionality - add, remove, change: owner, contracts, managers at the proxy gateway Contract