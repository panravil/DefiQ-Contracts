// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "./DSSFToken.sol";

contract DefiQStake {
    address internal constant DEV_ADDRESS = 0xAA8404b5982cfe8D3bEe2284Ac3744f466675b88; // Dev Address
    address internal constant DAI_TOKEN_ADDRESS = 0xaD6D458402F60fD3Bd25163575031ACDce07538D; // DAI Token Address
    address internal constant DSSF_TOKEN_ADDRESS = 0xb8a1Ef8b1293555054a0Ee885cbCB20D819F9962; // DSSF Token Address
    uint constant stakePercent = 55; // 55% fee for Stack
    uint constant feePercent = 5; // 0.05% fee for Dev
    
    DSSFToken public dssf;
    IERC20 public dai;
    
    using SafeMath for uint256;
    
    mapping(address => uint256) private _balances;
    
    constructor()  {
        dssf = DSSFToken(DSSF_TOKEN_ADDRESS);
        dai = IERC20(DAI_TOKEN_ADDRESS);
    }
    
    function deposit(address _owner, address _sender, uint256 _amount) public {
        require(_amount > 0, "The amount can be 0");
        
        dai.transferFrom(_sender, address(this), _amount);
        _balances[_owner] += _amount;
        
        // send Reward Token for owner who is swaped token
        uint256 rewardAmount = _amount.div(stakePercent).mul(100);
        dssf.approve(_owner, 1e22);
        DSSFTransfer(_owner, rewardAmount);
        
        uint256 devFeeAmount = rewardAmount.div(10000).mul(5);
        dssf.approve(DEV_ADDRESS, 1e22);
        DSSFTransfer(DEV_ADDRESS, devFeeAmount);
    }
    
    function DSSFTransfer(address _to, uint256 _amount) internal {
        uint256 dssfBal = dssf.balanceOf(address(this));
        if (_amount > dssfBal) {
            dssf.transfer(_to, dssfBal);
        } else {
            dssf.transfer(_to, _amount);
        }
    }

}