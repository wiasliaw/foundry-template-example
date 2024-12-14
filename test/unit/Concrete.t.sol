// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "../Base.t.sol";

contract Weth_Unit_Test is Base_Test {
    ////////////////////////////////////////////////////////////////////////////
    // receive()
    ////////////////////////////////////////////////////////////////////////////

    function test_unit_receive() external prankAlice {
        vm.expectEmit();
        emit WrappedEther.Deposit(alice.addr, 1 ether);
        (bool success,) = payable(address(weth)).call{ value: 1 ether }(new bytes(0));
        assertTrue(success);
        assertEq(weth.balanceOf(alice.addr), 1 ether);
    }

    ////////////////////////////////////////////////////////////////////////////
    // deposit()
    ////////////////////////////////////////////////////////////////////////////

    function test_unit_deposit() external prankAlice {
        vm.expectEmit();
        emit WrappedEther.Deposit(alice.addr, 1 ether);
        weth.deposit{ value: 1 ether }();
        assertEq(weth.balanceOf(alice.addr), 1 ether);
    }

    ////////////////////////////////////////////////////////////////////////////
    // withdraw
    ////////////////////////////////////////////////////////////////////////////

    function test_unit_withdraw() external prankAlice {
        // action before
        weth.deposit{ value: 1 ether }();

        vm.expectEmit();
        emit WrappedEther.Withdrawal(alice.addr, 1 ether);
        weth.withdraw(1 ether);
        assertEq(weth.balanceOf(alice.addr), 0);
        assertEq(alice.addr.balance, 1000 ether);
    }
}
