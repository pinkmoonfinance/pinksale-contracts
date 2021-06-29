// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0;

interface ILiquidityGeneratorToken {
    function initialize (
        address owner_,
        string memory name_, 
        string memory symbol_, 
        uint256 totalSupply_, 
        address router_,
        address charityAddress_,
        uint16 taxFeeBps_, 
        uint16 liquidityFeeBps_,
        uint16 charityFeeBps_,
        uint16 maxTxBps_
    ) external;
}