// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Local imports

// Interface imports
import "../../interfaces/core/ISugarcaneFactory.sol";
import "../utils/ManagerUtil.sol";
import "./SugarcaneHoldings.sol";

// The smart contract wallet that the signer controls on various chains
contract SugarcaneFactory is ManagerUtil, ISugarcaneFactory {
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    /**
     * @notice Initializes the contract.
     */
    function initialize(address managerAddress_) public initializer {
        __ManagerUtil_init(managerAddress_);

        __SugarcaneFactory_init_unchained();
    }

    function __SugarcaneFactory_init_unchained() internal initializer {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    /**
     * @notice Only the manager can talk to this function Sends back the address of the created holdings
     */
    function createHoldingsAccount(
        uint256 signerChainId_,
        address signerAddress_
    )
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneManager
        returns (address)
    {
        // Deploy a new sugarcane holdings for the signer
        SugarcaneHoldings sugarcaneHoldings = new SugarcaneHoldings(
            _manager(),
            signerChainId_,
            signerAddress_
        );

        emit HoldingsAccountCreated(
            _msgSender(),
            address(sugarcaneHoldings),
            signerChainId_,
            signerAddress_
        );

        // Return the address of the holdings
        return address(sugarcaneHoldings);
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[50] private __gap;
}
