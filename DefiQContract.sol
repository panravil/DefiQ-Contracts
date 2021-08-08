// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
import "./DSSFToken.sol";

contract DefiQContract {
    address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant DAI_TOKEN_ADDRESS = 0xaD6D458402F60fD3Bd25163575031ACDce07538D;
    
    IUniswapV2Router02 public uniswap;
    
    DSSFToken public dss;
    
    constructor() {
        uniswap = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
    }
    
    function swapEthToToken() public payable returns(uint[] memory) {
        address[] memory path = new address[](2);
        path[0] = uniswap.WETH();
        path[1] = DAI_TOKEN_ADDRESS;
        uint deadline = block.timestamp;
        uint[] memory amounts = uniswap.swapExactETHForTokens{value:msg.value}(0, path, address(this), deadline);
       
        
        return amounts;
    }
    
}

