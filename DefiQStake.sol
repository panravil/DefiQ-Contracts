// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./DSSFToken.sol";

contract DefiQStake {
    address internal constant DEV_ADDRESS = 0xAA8404b5982cfe8D3bEe2284Ac3744f466675b88; // Dev Address
    uint constant feePercent = 5; // 0.05% fee for Dev
    DSSFToken public dss;
    
    constructor(
        DSSFToken _dss
    )  {
        dss = _dss;
    }
}
