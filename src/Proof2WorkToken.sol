// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract Proof2WorkToken is Initializable, ERC20Upgradeable, ERC20PausableUpgradeable, OwnableUpgradeable, ERC20PermitUpgradeable {

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) initializer public {
        __ERC20_init("Proof2Work", "P2W");
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        __ERC20Permit_init("Proof2Work");

        _mint(initialOwner, 1000000000 * 10 ** decimals());
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function claim() public {
        uint256 amount = 10 * 10 ** decimals();
        require(balanceOf(owner()) >= amount, "Contract does not have enough tokens to burn");
        require(balanceOf(msg.sender) < amount, "Proof2Work: you already claimed your tokens");
        _burn(owner(), amount);
        _mint(msg.sender, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20Upgradeable, ERC20PausableUpgradeable)
    {
        super._update(from, to, value);
    }
}
