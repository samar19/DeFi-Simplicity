// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";
import "../core/ISugarcaneManagerBase.sol";

// The registry of what investments a given signer has
interface ISugarcaneManagerPrimaryBase is ISugarcaneManagerBase {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when the Sugarcane Badge  is updated
     * @param admin The admin that made the update
     * @param oldSugarcaneBadge The old Sugarcane Badge
     * @param newSugarcaneBadge The new Sugarcane Badge
     */
    event SugarcaneBadgeUpdated(
        address indexed admin,
        address indexed oldSugarcaneBadge,
        address indexed newSugarcaneBadge
    );

    /**
     * @notice Emitted when the Investment registry is updated
     * @param admin The admin that made the update
     * @param oldInvestmentRegistry The old Investment registry
     * @param newInvestmentRegistry The new Investment registry
     */
    event InvestmentRegistryUpdated(
        address indexed admin,
        address indexed oldInvestmentRegistry,
        address indexed newInvestmentRegistry
    );

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends back the address of the badge
     */
    function sugarcaneBadge() external view returns (address);

    /**
     * @notice Sends back the address of the investment registry
     */
    function investmentRegistry() external view returns (address);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    /**
     * @notice Talks to the investment registry to record an investment
     */
    function recordInvestment(
        address signerAddress_,
        uint256 chainId_,
        uint256 protocolId_,
        uint256 initialAmountUsd_
    ) external;

    /**
     * @notice Sets the address of the investment registry
     * @param investmentRegistry_ the address of the investment registry
     */
    function setInvestmentRegistry(address investmentRegistry_) external;

    /**
     * @notice Sets the address of the sugarcane badge
     * @param sugarcaneBadge_ the address of the sugarcane badge
     */
    function setSugarcaneBadge(address sugarcaneBadge_) external;
}
