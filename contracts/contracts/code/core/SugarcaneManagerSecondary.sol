// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Libraries
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

// Local imports
import "../libs/StringOperations.sol";
import "../libs/SugarcaneLib.sol";

// Interface imports
import "./SugarcaneManagerBase.sol";
import "../../interfaces/core/ISugarcaneManagerSecondary.sol";

//  The manager on a non-canonical chain
contract SugarcaneManagerSecondary is
    SugarcaneManagerBase,
    ISugarcaneManagerSecondary
{
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    using SafeMathUpgradeable for uint256;
    using StringOperations for string;

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //
    uint256 public nonce;
    address private __executeOnboardReceiver;

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
        address gasService_
    ) public initializer {
        __SugarcaneManagerBase_init(chainId_, gateway_, gasService_);

        __SugarcaneManagerSecondary_init_unchained();
    }

    function __SugarcaneManagerSecondary_init_unchained()
        internal
        initializer
    {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Throws if message sender is not the onboard execute receiver contract.
     */
    modifier onlyOnboardExecuteReceiver() {
        require(
            __executeOnboardReceiver == _msgSender(),
            "ManagerBase: not onboarder"
        );
        _;
    }

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Returns the execute onboard receiver address
     */
    function executeOnboardReceiver()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address)
    {
        return _executeOnboardReceiver();
    }

    /**
     * @notice Returns the execute onboard receiver address
     */
    function _executeOnboardReceiver() internal view returns (address) {
        return __executeOnboardReceiver;
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sets the address of the execute Onboard Receiver
     * @param executeOnboardReceiver_ the address of the execute Onboard Receiver
     */
    function setExecuteOnboardReceiver(address executeOnboardReceiver_)
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneAdmin
    {
        _setExecuteOnboardReceiver(executeOnboardReceiver_);
    }

    /**
     * @notice Sets the address of the execute Onboard Receiver
     * @param executeOnboardReceiver_ the address of the execute Onboard Receiver
     */
    function _setExecuteOnboardReceiver(address executeOnboardReceiver_)
        internal
    {
        address oldExecuteOnboardReceive = __executeOnboardReceiver;
        __executeOnboardReceiver = executeOnboardReceiver_;

        emit ExecuteOnboardReceiverUpdated(
            _msgSender(),
            _chainId(),
            oldExecuteOnboardReceive,
            executeOnboardReceiver_
        );
    }

    /**
     * @notice Only the Sugarcane_Onboard_Execute_Receiver_Secondary contract can talk to this.
     * @param signerAddress_ the address of the account to onboard
     */
    function onboardAccount(address signerAddress_)
        external
        override(ISugarcaneManagerBase, SugarcaneManagerBase)
        nonReentrant
        whenNotPausedExceptAdmin
        onlyOnboardExecuteReceiver
    {
        // Talks to the Sugarcane_Factory.createHoldingsAccount(userAddress_) to create holdings on this chain
        // Run onboard locally
        _onboardAccount(signerAddress_);

        // Send a message to the primary chain that the account has been onboarded
        // Talks to the gateway() to let the primary manager know what this chain’s holdings is
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[48] private __gap;
}
