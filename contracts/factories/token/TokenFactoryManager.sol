// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "../../interfaces/IFactoryManager.sol";

contract TokenFactoryManager is Ownable, IFactoryManager {
  using EnumerableSet for EnumerableSet.AddressSet;

  struct Token {
    uint8 tokenType;
    address tokenAddress;
  }

  EnumerableSet.AddressSet private tokenFactories;
  mapping(address => Token[]) private tokensOf;
  mapping(address => mapping(address => bool)) private hasToken;
  mapping(address => bool) private isGenerated;

  modifier onlyAllowedFactory() {
    require(tokenFactories.contains(msg.sender), "Not a whitelisted factory");
    _;
  }

  function addTokenFactory(address factory) public onlyOwner {
    tokenFactories.add(factory);
  }

  function addTokenFactories(address[] memory factories) external onlyOwner {
    for (uint256 i = 0; i < factories.length; i++) {
      addTokenFactory(factories[i]);
    }
  }

  function removeTokenFactory(address factory) external onlyOwner {
    tokenFactories.remove(factory);
  }

  function assignTokensToOwner(address owner, address token, uint8 tokenType) 
    external override onlyAllowedFactory {
    require(!hasToken[owner][token], "Token already exists");
    tokensOf[owner].push(Token(tokenType, token));
    hasToken[owner][token] = true;
    isGenerated[token] = true;
  }

  function getAllowedFactories() public view returns (address[] memory) {
    uint256 length = tokenFactories.length();
    address[] memory factories = new address[](length);
    for (uint256 i = 0; i < length; i++) {
      factories[i] = tokenFactories.at(i);
    }
    return factories;
  }

  function isTokenGenerated(address token) external view returns (bool) {
    return isGenerated[token];
  }

  function getToken(address owner, uint256 index) external view returns (address, uint8) {
    if (index > tokensOf[owner].length) {
      return (address(0), 0);
    }
    return (tokensOf[owner][index].tokenAddress, uint8(tokensOf[owner][index].tokenType));
  }

  function getAllTokens(address owner) external view returns (address[] memory, uint8[] memory) {
      uint256 length = tokensOf[owner].length;
      address[] memory tokenAddresses = new address[](length);
      uint8[] memory tokenTypes = new uint8[](length);
      for (uint256 i = 0; i < length; i++) {
        tokenAddresses[i] = tokensOf[owner][i].tokenAddress;
        tokenTypes[i] = uint8(tokensOf[owner][i].tokenType);
      }
      return (tokenAddresses, tokenTypes);
   }

   function getTokensForType(address owner, uint8 tokenType) external view returns (address[] memory) {
      uint256 length = 0;
      for (uint256 i = 0; i < tokensOf[owner].length; i++) {
        if (tokensOf[owner][i].tokenType == tokenType) {
          length++;
        }
      }
      address[] memory tokenAddresses = new address[](length);
      if (length == 0) {
        return tokenAddresses;
      }
      uint256 currentIndex;
      for (uint256 i = 0; i < tokensOf[owner].length; i++) {
        if (tokensOf[owner][i].tokenType == tokenType) {
          tokenAddresses[currentIndex] = tokensOf[owner][i].tokenAddress;
          currentIndex++;
        }
      }
      return tokenAddresses;
   }
}