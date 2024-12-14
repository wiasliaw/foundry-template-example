// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import { Invariant_Test } from "./invariant.t.sol";

contract Weth_Invariant_Test is Invariant_Test {
    function invariant_conservationOfETH() public {
        uint256 total_eth = 200 ether;
        assertEq(total_eth, weth.totalSupply() + handler.aliceBalance() + handler.bobEth());
        assertEq(weth.totalSupply(), handler.aliceWeth() + handler.bobWeth());
    }
}
