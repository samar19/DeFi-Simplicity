// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Libraries
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

// Local imports
import "../libs/StringOperations.sol";
import "../libs/SugarcaneLib.sol";
import "./SugarcaneOnboardExecuteReceiverBase.sol";

// Interface imports
import "../../interfaces/core/ISugarcaneOnboardExecuteReceiverSecondary.sol";

// The contract on the secondary chains that updates the manager after onboarding a user
contract SugarcaneOnboardExecuteReceiverSecondary is
    SugarcaneOnboardExecuteReceiverBase,
    ISugarcaneOnboardExecuteReceiverSecondary
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
        address secondaryManagerAddress_
    ) public initializer {
        __SugarcaneOnboardExecuteReceiverBase_init(
            // uint256 chainId_,
            chainId_,
            // address gateway_,
            gateway_,
            // address managerAddress_
            secondaryManagerAddress_
        );

        __SugarcaneOnboardExecuteReceiverSecondary_init_unchained();
    }

    function __SugarcaneOnboardExecuteReceiverSecondary_init_unchained()
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
    
    */
    /**
     * @notice Talks to the Sugarcane manager that is on this chain to run
     */

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal override {
        (uint256 nonce_, address signerAddress_) = abi.decode(
            payload,
            (uint256, address)
        );
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[50] private __gap;
}
