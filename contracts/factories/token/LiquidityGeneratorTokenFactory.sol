// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./TokenFactoryBase.sol";
import "../../interfaces/ILiquidityGeneratorToken.sol";


contract LiquidityGeneratorTokenFactory is TokenFactoryBase {
  using Address for address payable;

  constructor(address factoryManager_, address implementation_) TokenFactoryBase(factoryManager_, implementation_) {}

  function create(
    string memory name,
    string memory symbol,
    uint256 totalSupply,
    address router,
    address charity,
    uint16 taxFeeBps, 
    uint16 liquidityFeeBps,
    uint16 charityBps,
    uint16 maxTxBps
  ) external payable enoughFee nonReentrant returns (address token) {
    refundExcessiveFee();
    payable(feeTo).sendValue(flatFee);
    token = Clones.clone(implementation);
    ILiquidityGeneratorToken(token).initialize(
      msg.sender,
      name,
      symbol,
      totalSupply,
      router,
      charity,
      taxFeeBps,
      liquidityFeeBps,
      charityBps,
      maxTxBps
    );
    assignTokenToOwner(msg.sender, token, 1);
    emit TokenCreated(msg.sender, token, 1);
  }
}