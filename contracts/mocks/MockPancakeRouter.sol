// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.6;

import './libraries/SafeMath.sol';
import './libraries/Math.sol';

contract MockPancakeRouter {
  using SafeMath for uint256;

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external payable returns (
      uint256 amountToken,
      uint256 amountETH,
      uint256 liquidity
  ) {
    
    return (amountTokenDesired, msg.value, Math.sqrt(amountTokenDesired.mul(msg.value)));
  }
}