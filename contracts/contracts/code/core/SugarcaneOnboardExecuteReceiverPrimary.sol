// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Libraries
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

// Local imports
import "../libs/StringOperations.sol";
import "../libs/SugarcaneLib.sol";
import "./SugarcaneOnboardExecuteReceiverBase.sol";

// Interface imports
import "../../interfaces/core/ISugarcaneOnboardExecuteReceiverPrimary.sol";

// Meant to be the communication channel back from the separate chains back to
// Goerli, this contract updates the state of the Goerli Manager
contract SugarcaneOnboardExecuteReceiverPrimary is
    SugarcaneOnboardExecuteReceiverBase,
    ISugarcaneOnboardExecuteReceiverPrimary
{
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    using SafeMathUpgradeable for uint256;
    using StringOperations for string;

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
    function initialize(
        uint256 chainId_,
        address gateway_,
        address primaryManagerAddress_
    ) public initializer {
        __SugarcaneOnboardExecuteReceiverBase_init(
            // uint256 chainId_,
            chainId_,
            // address gateway_,
            gateway_,
            // address managerAddress_
            primaryManagerAddress_
        );

        __SugarcaneOnboardExecuteReceiverPrimary_init_unchained();
    }

    function __SugarcaneOnboardExecuteReceiverPrimary_init_unchained()
        internal
        initializer
    {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    /*
    [READ] – _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    )
    Check that the sender to this de is the nonce that got communicated to
    Talks to the Sugarcane Primary Manager that is on this chain has and updates it’s record of list of addresses
    */

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal override {}

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[50] private __gap;
}
