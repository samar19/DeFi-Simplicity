// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Connected parts of the system
import "../utils/IManagerUtil.sol";

// The contract that produces more holdings contracts
interface ISugarcaneFactory is IManagerUtil {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when the holdings account is created
     * @param manager The admin that made the update
     * @param sugarcaneHoldings The address of the holdings contract
     * @param signerChainId The chain this was deployed on
     * @param signerAddress The signer who owns the holdings
     */
    event HoldingsAccountCreated(
        address manager,
        address indexed sugarcaneHoldings,
        uint256 indexed signerChainId,
        address indexed signerAddress
    );

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
    ) external returns (address);
}
