// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0;

interface IFactoryManager {
  function assignTokensToOwner(address owner, address token, uint8 tokenType) external;
}