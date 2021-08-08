// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
import "./DefiQStake.sol";

contract DefiQContract {
    address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap Roter Address
    address internal constant DAI_TOKEN_ADDRESS = 0xaD6D458402F60fD3Bd25163575031ACDce07538D; // Dai Token Address
    address internal constant STAKE_CONTRACT_ADDRESS = 0x5eCd54c4034a73A8AFe7e40132B5a241143a8725; // Staking Conract Address
    
    DefiQStake public defiqStake;
    IERC20 public dai;
    IUniswapV2Router02 public uniswap;
    
    mapping(address => uint256) private _balances;
    
    constructor() {
        uniswap = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
        defiqStake = DefiQStake(STAKE_CONTRACT_ADDRESS);
        dai = IERC20(DAI_TOKEN_ADDRESS);
    }
    
    function swapEthToToken() public payable returns(bool) {
        address[] memory path = new address[](2);
        path[0] = uniswap.WETH();
        path[1] = DAI_TOKEN_ADDRESS;
        uint deadline = block.timestamp;
        uint[] memory amounts = uniswap.swapExactETHForTokens{value:msg.value}(0, path, address(this), deadline);
        uint256 outputAmount = uint256(amounts[amounts.length - 1]);
        _balances[DAI_TOKEN_ADDRESS] += outputAmount;
        
        // Approve token on Stake Contract
        dai.approve(STAKE_CONTRACT_ADDRESS, outputAmount);
        
        // Deposit to Stake Contract
        defiqStake.deposit(msg.sender, address(this), outputAmount);
        
        return true;
    }
    
    function balanceOf() public view returns(uint256) {
        return _balances[DAI_TOKEN_ADDRESS];
    }
}
