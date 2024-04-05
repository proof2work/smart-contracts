// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import "../src/Proof2WorkToken.sol"; // Adjust the path according to your project structure

contract Proof2WorkTest is Test {
    Proof2WorkToken public proxy;
    address implementationAddress;
    address proxyAddress;
    address owner = address(1);

    function setUp() public {
        address _proxyAddress = Upgrades.deployTransparentProxy(
            "Proof2WorkToken.sol",
            owner,
            abi.encodeCall(Proof2WorkToken.initialize, (owner))
        );

        implementationAddress = Upgrades.getImplementationAddress(
            _proxyAddress
        );
        proxyAddress = _proxyAddress;
        proxy = Proof2WorkToken(proxyAddress);
    }

    function testOwnerships() public view {
        // Test ownerships
        assertEq(
            proxy.owner(),
            owner,
            "Owner of the contract is not the expected owner"
        );
    }

    function testInitialMint() public view {
        // Test initial minting to the safe wallet
        uint256 expectedBalance = 1000000000 * 10 ** proxy.decimals();
        assertEq(
            proxy.balanceOf(owner),
            expectedBalance,
            "Initial minting failed"
        );
    }

    function testPauseAndUnpause() public {
        // Test pausing and unpausing the contract
        vm.prank(owner); // Prank the safe wallet to allow pausing
        proxy.pause();
        assertTrue(proxy.paused(), "Contract should be paused");

        vm.prank(owner); // Prank the safe wallet to allow pausing
        proxy.unpause();
        assertFalse(proxy.paused(), "Contract should be unpaused");
    }

    function testClaim() public {
        // Prepare for claim test
        uint256 expectedBalance = 10 * 10 ** proxy.decimals(); // Should have 20 tokens after claim
        uint256 initBalance = 1000000000 * 10 ** proxy.decimals();
        address claimer = address(2);
        vm.prank(claimer);
        proxy.claim(); // Ensuring claimer has now 10 tokens
        assertEq(
            proxy.balanceOf(claimer),
            expectedBalance,
            "Claimer does not have the expected balance of tokens"
        );
        assertLt(
            proxy.balanceOf(owner),
            initBalance,
            "Owner did not loose tokens during the claim"
        );
    }

    function testMint() public {
        // Test minting additional tokens
        address recipient = address(3);
        uint256 mintAmount = 500 * 10 ** proxy.decimals();
        vm.prank(owner);
        proxy.mint(recipient, mintAmount);

        assertEq(
            proxy.balanceOf(recipient),
            mintAmount,
            "Minting did not allocate the correct amount of tokens"
        );
    }
}
