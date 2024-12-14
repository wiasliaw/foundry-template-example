// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { WrappedEther } from "../../../src/WrappedEther.sol";

contract Handler is Test {
    ////////////////////////////////////////////////////////////////////////////
    // variables
    ////////////////////////////////////////////////////////////////////////////

    WrappedEther public immutable weth;

    // actor: alice
    Account internal alice;

    // actor: bob
    Account internal bob;

    // tracking actor
    address internal tracking_actor;

    // tracking variables
    uint256 public tracking_deposit;

    // tracking variables
    uint256 public tracking_withdraw;

    ////////////////////////////////////////////////////////////////////////////
    // constructor
    ////////////////////////////////////////////////////////////////////////////

    constructor(WrappedEther instance) {
        weth = instance;

        // init actors
        alice = makeAccount("Alice");
        bob = makeAccount("Bob");
        deal(alice.addr, 100 ether);
        deal(bob.addr, 100 ether);
    }

    ////////////////////////////////////////////////////////////////////////////
    // helper
    ////////////////////////////////////////////////////////////////////////////

    modifier useActor(uint256 seed) {
        if (seed % 2 == 0) {
            tracking_actor = alice.addr;
        } else {
            tracking_actor = bob.addr;
        }

        vm.startPrank(tracking_actor);
        _;
        vm.stopPrank();
    }

    function aliceBalance() public view returns (uint256) {
        return alice.addr.balance;
    }

    function aliceWeth() public view returns (uint256) {
        return weth.balanceOf(alice.addr);
    }

    function bobEth() public view returns (uint256) {
        return bob.addr.balance;
    }

    function bobWeth() public view returns (uint256) {
        return weth.balanceOf(bob.addr);
    }

    ////////////////////////////////////////////////////////////////////////////
    // handler wrapper functions
    ////////////////////////////////////////////////////////////////////////////

    function handleDeposit(uint256 seed_, uint256 value_) external useActor(seed_) {
        // constraint
        value_ = bound(value_, 0, tracking_actor.balance);
        // effect
        tracking_deposit += value_;
        // interact
        weth.deposit{ value: value_ }();
    }

    function handleWithdraw(uint256 seed_,uint256 value_) external useActor(seed_) {
        // constraint
        value_ = bound(value_, 0, weth.balanceOf(tracking_actor));
        // effect
        tracking_withdraw -= value_;
        // interact
        weth.withdraw(value_);
    }

    function handleReceive(uint256 seed_, uint256 value_) external useActor(seed_) {
        // constraint
        value_ = bound(value_, 0, tracking_actor.balance);
        // effect
        tracking_deposit += value_;
        // interact
        payable(address(weth)).call{ value: value_ }(new bytes(0));
    }

    // function handleApprove(address caller_, address spender_, uint256 value_) external useActor  {
    //     weth.approve(spender_, value_);
    // }

    // function handleTransfer(address caller_, address to_, uint256 value_) external useActor {
    //     weth.transfer(to_, value_);
    // }

    // function handleTransferFrom(
    //     address caller_,
    //     address from_,
    //     address to_,
    //     uint256 value_
    // ) external useActor {
    //     weth.transferFrom(from_, to_, value_);
    // }
}
