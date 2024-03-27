// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "../src/Proof2WorkToken.sol"; // Adjust the path according to your project structure

contract Proof2WorkTest is Test {
    Proof2Work public proof2Work;
    address safeWallet = address(1);
    address initialOwner = address(this);

    function setUp() public {
        proof2Work = new Proof2Work();
        proof2Work.initialize(initialOwner, safeWallet);
    }

    function testInitialMint() public {
        // Test initial minting to the safe wallet
        uint256 expectedBalance = 1000000000 * 10 ** proof2Work.decimals();
        assertEq(proof2Work.balanceOf(safeWallet), expectedBalance, "Initial minting failed");
    }

    function testPauseAndUnpause() public {
        // Test pausing and unpausing the contract
        proof2Work.pause();
        assertTrue(proof2Work.paused(), "Contract should be paused");

        proof2Work.unpause();
        assertFalse(proof2Work.paused(), "Contract should be unpaused");
    }

    function testClaim() public {
        // Prepare for claim test
        address claimer = address(2);
        vm.prank(safeWallet);
        proof2Work.mint(claimer, 10 * 10 ** proof2Work.decimals()); // Ensuring claimer has exactly 10 tokens

        // Test claim function
        vm.startPrank(claimer);
        proof2Work.claim();
        uint256 expectedBalance = 20 * 10 ** proof2Work.decimals(); // Should have 20 tokens after claim
        assertEq(proof2Work.balanceOf(claimer), expectedBalance, "Claim did not mint the correct amount of tokens");

        // Cleanup
        vm.stopPrank();
    }

    function testMint() public {
        // Test minting additional tokens
        address recipient = address(3);
        uint256 mintAmount = 500 * 10 ** proof2Work.decimals();
        proof2Work.mint(recipient, mintAmount);

        assertEq(proof2Work.balanceOf(recipient), mintAmount, "Minting did not allocate the correct amount of tokens");
    }
}
