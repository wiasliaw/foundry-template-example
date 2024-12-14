// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "../Base.s.sol";

contract SepoliaSystem is Base_Script {
    ////////////////////////////////////////////////////////////////////////////
    // Parameters
    ////////////////////////////////////////////////////////////////////////////

    // declare argument for deployment here

    ////////////////////////////////////////////////////////////////////////////
    // setUp
    ////////////////////////////////////////////////////////////////////////////

    function setUp() external {
        // load deployer account
        uint256 privateKey = vm.envUint("DEPLOYER_PRIVATEKEY");
        address addr = vm.addr(privateKey);
        deployer = Account({ addr: addr, key: privateKey });
    }

    ////////////////////////////////////////////////////////////////////////////
    // script
    ////////////////////////////////////////////////////////////////////////////

    /// @dev deployment
    /// @dev `forge script ./script/deployment/Sepolia.deployment.s.sol --broadcast --verify`
    function run() external Fork("sepolia") Broadcast(deployer.key) {
        weth = new WrappedEther();
    }

    /// @dev simulate deployment
    /// @dev `forge script ./script/deployment/Sepolia.deployment.s.sol --sig "sim()"`
    function sim() external Fork("sepolia") Prank(deployer.addr) {
        weth = new WrappedEther();
    }
}
