// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";

import "./ISugarcaneManagerBase.sol";

//  The manager on the canonical chain
interface ISugarcaneManagerPrimary is ISugarcaneManagerBase {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when the secondary manager address at a specific chain is updated
     * @param admin The admin that made the update
     * @param chainId The chain id of the chain this is deployed on
     * @param secondaryChainId The chain id of the secondary chain
     * @param oldSecondaryManager The old secondary chain address
     * @param newSecondaryManager The new secondary chain address
     */
    event SecondaryManagerUpdated(
        address indexed admin,
        uint256 chainId,
        uint256 indexed secondaryChainId,
        address oldSecondaryManager,
        address indexed newSecondaryManager
    );

    /**
     * @notice Emitted when the secondary chain holdings address is added
     * @param executeOnboardReceiver qwerty
     * @param chainId The chain id of the chain this is deployed on
     * @param secondaryChainId The chain id of the secondary chain
     * @param signerAddress The signer address
     * @param secondaryChainHoldingsAddress The secondary chain holdings address
     */
    event AddedSecondaryChainHoldingAddress(
        address executeOnboardReceiver,
        uint256 chainId,
        uint256 indexed secondaryChainId,
        address indexed signerAddress,
        address indexed secondaryChainHoldingsAddress
    );

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Returns the execute onboard receiver address
     */
    function secondaryChainHoldingAddress(address address_, uint256 chainId_)
        external
        view
        returns (SugarcaneLib.SecondaryHoldings memory);

    /**
     * @notice Returns the execute onboard receiver address
     */
    function executeOnboardReceiver() external view returns (address);

    /**
     * @notice Returns the secondary manager details
     */
    function secondaryManager(uint256 chainId_)
        external
        view
        returns (SugarcaneLib.SecondaryManager memory);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sets the address of the execute Onboard Receiver
     * @param executeOnboardReceiver_ the address of the execute Onboard Receiver
     */
    function setExecuteOnboardReceiver(address executeOnboardReceiver_)
        external;

    /**
     * @notice Sets the address of the manager on a different chain
     * @param secondaryManager_ the address of the manager on mumbai
     */
    function setSecondaryManager(uint256 chainId_, address secondaryManager_)
        external;

    /**
     * @notice This is a function only the Sugarcane_Onboard_Execute_Receiver_Primary contract can change it is
     */
    function addSecondaryChainHoldingAddress(
        uint256 secondaryChainId_,
        address signerAddress_,
        address secondaryChainHoldingsAddress_
    ) external;
}
