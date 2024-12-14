// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { Handler } from "./handles/Handler.sol";
import { WrappedEther } from "../../src/WrappedEther.sol";

abstract contract Invariant_Test is Test {
    ////////////////////////////////////////////////////////////////////////////
    // Test Contracts
    ////////////////////////////////////////////////////////////////////////////

    WrappedEther internal weth;

    Handler internal handler;

    ////////////////////////////////////////////////////////////////////////////
    // Setup
    ////////////////////////////////////////////////////////////////////////////

    function setUp() public virtual {
        // deploy contracts
        weth = new WrappedEther();
        handler = new Handler(weth);

        // label
        vm.label(address(weth), "WETH");
        vm.label(address(handler), "Handler");

        // target
        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = Handler.handleDeposit.selector;
        selectors[1] = Handler.handleWithdraw.selector;
        selectors[2] = Handler.handleReceive.selector;
        // selectors[3] = Handler.handleApprove.selector;
        // selectors[4] = Handler.handleTransfer.selector;
        // selectors[5] = Handler.handleTransferFrom.selector;

        targetSelector(FuzzSelector({ addr: address(handler), selectors: selectors }));
        targetContract(address(handler));
    }
}
