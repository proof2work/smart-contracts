// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Upgradeable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20PausableUpgradeable.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import "lib/openzeppelin-contracts/contracts/access/OwnableUpgradeable.sol";
import "lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";


contract Proof2Work is Initializable, ERC20Upgradeable, ERC20PausableUpgradeable, OwnableUpgradeable, ERC20PermitUpgradeable {

    address public safeWallet;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, address _safeWallet) initializer public {
        __ERC20_init("Proof2Work", "P2W");
        __ERC20Pausable_init();
        __Ownable_init(initialOwner);
        __ERC20Permit_init("Proof2Work");

        safeWallet = _safeWallet;
        _mint(safeWallet, 1000000000 * 10 ** decimals());
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
        require(balanceOf(safeWallet) >= amount, "Contract does not have enough tokens to burn");
        require(balanceOf(msg.sender) == 10, "Proof2Work: you already claimed your tokens");
        _burn(safeWallet, amount);
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
