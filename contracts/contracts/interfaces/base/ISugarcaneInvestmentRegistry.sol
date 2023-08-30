// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";
import "../utils/IManagerUtil.sol";

// The registry of what investments a given signer has
interface ISugarcaneInvestmentRegistry is IManagerUtil {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when there is an investment added
     * @param manager The manager address that made the update
     * @param signerAddress The signer address
     * @param chainId The id of the investment
     * @param protocolId The id of the investment
     * @param investmentId The id of the investment
     * @param overallInvestmentIndex The index of the investment for this signer
     * @param protocolSpecificInvestmentIndex The protocol specific index of the investment for this signer
     */
    event InvestmentAdded(
        address manager,
        address indexed signerAddress,
        uint256 indexed chainId,
        uint256 indexed protocolId,
        uint256 investmentId,
        uint256 overallInvestmentIndex,
        uint256 protocolSpecificInvestmentIndex
    );

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Gets all the investments that have been added for this address
     * @return returns full list of the investments
     */
    function investments(address signerAddress_)
        external
        view
        returns (uint256[] memory);

    /**
     * @notice Gets all the investments for a specific protocol that have been added for this address
     * @return returns full list of the investments for a specific protocol
     */
    function investmentsForProtocol(address signerAddress_, uint256 protocolId_)
        external
        view
        returns (uint256[] memory);

    /**
     * @notice Get the details of a specific investment
     * @return returns the details of the investment
     */
    function investmentDetails(uint256 investmentId_)
        external
        view
        returns (SugarcaneLib.Investment memory);

    /**
     * @notice Combines the signer address and the investment index to create a unique id
     * @return returns the investment id
     */
    function investmentIdHash(address signerAddress_, uint256 investmentIndex_)
        external
        view
        returns (uint256);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Adds the investment to the signer
     */
    function addInvestment(
        address signerAddress_,
        uint256 chainId_,
        uint256 protocolId_,
        uint256 initialAmountUsd_
    ) external;
}
