// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "../Base.t.sol";

contract Weth_Fuzz_Test is Base_Test {
    ////////////////////////////////////////////////////////////////////////////
    // receive()
    ////////////////////////////////////////////////////////////////////////////

    function test_fuzz_receive(uint256 value) external prankAlice {
        // assume
        value = bound(value, 0, 1000 ether);

        vm.expectEmit();
        emit WrappedEther.Deposit(alice.addr, value);
        (bool success,) = payable(address(weth)).call{ value: value }(new bytes(0));
        assertTrue(success);
        assertEq(weth.balanceOf(alice.addr), value);
    }

    ////////////////////////////////////////////////////////////////////////////
    // deposit()
    ////////////////////////////////////////////////////////////////////////////

    function test_fuzz_deposit(uint256 value) external prankAlice {
        // assume
        value = bound(value, 0, 1000 ether);

        vm.expectEmit();
        emit WrappedEther.Deposit(alice.addr, 1 ether);
        weth.deposit{ value: 1 ether }();
        assertEq(weth.balanceOf(alice.addr), 1 ether);
    }

    ////////////////////////////////////////////////////////////////////////////
    // withdraw
    ////////////////////////////////////////////////////////////////////////////

    function test_fuzz_withdraw(uint256 value) external prankAlice {
        // assume
        value = bound(value, 0, 1000 ether);

        // action before
        weth.deposit{ value: 1 ether }();

        vm.expectEmit();
        emit WrappedEther.Withdrawal(alice.addr, 1 ether);
        weth.withdraw(1 ether);
        assertEq(weth.balanceOf(alice.addr), 0);
        assertEq(alice.addr.balance, 1000 ether);
    }
}
