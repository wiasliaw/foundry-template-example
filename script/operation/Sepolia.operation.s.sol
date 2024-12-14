// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "./config/Sepolia.config.sol";

contract SepoliaOperation is Sepolia_Config {
    ////////////////////////////////////////////////////////////////////////////
    // setUp
    ////////////////////////////////////////////////////////////////////////////

    function setUp() public override {
        super.setUp();
        // load operator account
        uint256 privateKey = vm.envUint("OPERATOR_PRIVATEKEY");
        address addr = vm.addr(privateKey);
        operator = Account({ addr: addr, key: privateKey });
    }

    ////////////////////////////////////////////////////////////////////////////
    // operations
    ////////////////////////////////////////////////////////////////////////////

    /// @notice `forge script ./script/operation/Sepolia.operation.s.sol --sig "operation_balanceOf"`
    function operation_balanceOf() external Fork("sepolia") {
        address account = vm.promptAddress("account");
        console.log("WETH balance: ", weth.balanceOf(account));
    }

    /// @notice forge script ./script/operation/Sepolia.operation.s.sol --sig "operation_deposit" --broadcast
    function operation_deposit() external Fork("sepolia") Broadcast(operator.key) {
        uint256 value = vm.promptUint("allowance amount");
        weth.deposit{value: value}();
    }

    /// @notice forge script ./script/operation/Sepolia.operation.s.sol --sig "operation_withdraw" --broadcast
    function operation_withdraw() external Fork("sepolia") Broadcast(operator.key) {
        uint256 value = vm.promptUint("allowance amount");
        require(value <= weth.balanceOf(operator.addr), "insufficient");
        weth.withdraw(value);
    }

    /// @notice forge script ./script/operation/Sepolia.operation.s.sol --sig "operation_transfer" --broadcast
    function operation_transfer() external Fork("sepolia") Broadcast(operator.key) {
        address to = vm.promptAddress("receiver address");
        uint256 value = vm.promptUint("allowance amount");
        weth.transfer(to, value);
    }

    /// @notice forge script ./script/operation/Sepolia.operation.s.sol --sig "operation_transferFrom" --broadcast
    function operation_transferFrom() external Fork("sepolia") Broadcast(operator.key) {
        address from = vm.promptAddress("from address");
        address to = vm.promptAddress("to address");
        uint256 value = vm.promptUint("allowance amount");
        weth.transferFrom(from, to, value);
    }

    /// @notice forge script ./script/operation/Sepolia.operation.s.sol --sig "operation_approve" --broadcast
    function operation_approve() external Fork("sepolia") Broadcast(operator.key) {
        address spender = vm.promptAddress("spender address");
        uint256 value = vm.promptUint("allowance amount");
        weth.approve(spender, value);
    }
}
