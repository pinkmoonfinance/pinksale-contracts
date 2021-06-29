// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./TokenFactoryBase.sol";
import "../../interfaces/IStandardERC20.sol";

contract StandardTokenFactory is TokenFactoryBase {
  using Address for address payable;
  using SafeMath for uint256;
  constructor(address factoryManager_, address implementation_) TokenFactoryBase(factoryManager_, implementation_) {}

  function create(
    string memory name, 
    string memory symbol, 
    uint8 decimals, 
    uint256 totalSupply
  ) external payable enoughFee nonReentrant returns (address token) {
    refundExcessiveFee();
    payable(feeTo).sendValue(flatFee);
    token = Clones.clone(implementation);
    IStandardERC20(token).initialize(msg.sender, name, symbol, decimals, totalSupply);
    assignTokenToOwner(msg.sender, token, 0);
    emit TokenCreated(msg.sender, token, 0);
  }
}