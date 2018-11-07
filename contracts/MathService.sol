/*
__This contract shows an example of a service contract
-contracts for common and repetitive functions e.g. math functions
*/

pragma solidity >=0.4.0 <0.6.0;

contract MathService {

    // calculate the majority of current owners in the system
    function calculateOwnerMajority(uint8 countOwner) public pure returns (uint8) {

        uint8 majority = countOwner / 2;

        return majority;

    }

}
