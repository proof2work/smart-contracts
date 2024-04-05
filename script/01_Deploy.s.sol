// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import "../src/Proof2WorkToken.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract DeployScript is Script {

    function run() external returns (address, address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the upgradeable contract
        address _proxyAddress = Upgrades.deployTransparentProxy(
            "Proof2WorkToken.sol",
            msg.sender,
            abi.encodeCall(Proof2WorkToken.initialize, (msg.sender))
        );

        // Get the implementation address
        address implementationAddress = Upgrades.getImplementationAddress(
            _proxyAddress
        );

        vm.stopBroadcast();

        return (implementationAddress, _proxyAddress);
    }
}
