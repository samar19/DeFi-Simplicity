// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Local imports
import "../libs/SugarcaneLib.sol";

// Interface imports
import "../../interfaces/base/ISugarcaneInvestmentRegistry.sol";
import "../utils/ManagerUtil.sol";

// The registry of what investments a given signer has
contract SugarcaneInvestmentRegistry is
    ManagerUtil,
    ISugarcaneInvestmentRegistry
{
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //

    mapping(address => uint256[]) internal _addressToInvestmentIds;
    mapping(uint256 => uint256[]) internal _specificProtocolInvestmentMap;
    mapping(uint256 => SugarcaneLib.Investment) internal _investmentIdToDetails;

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

        __SugarcaneInvestmentRegistry_init_unchained();
    }

    function __SugarcaneInvestmentRegistry_init_unchained()
        internal
        initializer
    {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // UTILS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Combines the address and the number to create a unique id
     * @return returns the hash of the two put together
     */
    function _addressAndNumberHash(address address_, uint256 enteredNumber_)
        internal
        pure
        returns (uint256)
    {
        return
            uint256(keccak256(abi.encodePacked(address_, "-", enteredNumber_)));
    }

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
        override
        whenNotPausedExceptAdmin
        returns (uint256[] memory)
    {
        return _investments(signerAddress_);
    }

    /**
     * @notice Gets all the investments that have been added for this address
     * @return returns full list of the investments
     */
    function _investments(address signerAddress_)
        internal
        view
        returns (uint256[] memory)
    {
        return _addressToInvestmentIds[signerAddress_];
    }

    /**
     * @notice Gets all the investments for a specific protocol that have been added for this address
     * @return returns full list of the investments for a specific protocol
     */
    function investmentsForProtocol(address signerAddress_, uint256 protocolId_)
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (uint256[] memory)
    {
        return _investmentsForProtocol(signerAddress_, protocolId_);
    }

    /**
     * @notice Gets all the investments for a specific protocol that have been added for this address
     * @return returns full list of the investments for a specific protocol
     */
    function _investmentsForProtocol(
        address signerAddress_,
        uint256 protocolId_
    ) internal view returns (uint256[] memory) {
        return
            _specificProtocolInvestmentMap[
                _addressAndNumberHash(signerAddress_, protocolId_)
            ];
    }

    /**
     * @notice Get the details of a specific investment
     * @return returns the details of the investment
     */
    function investmentDetails(uint256 investmentId_)
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (SugarcaneLib.Investment memory)
    {
        return _investmentDetails(investmentId_);
    }

    /**
     * @notice Get the details of a specific investment
     * @return returns the details of the investment
     */
    function _investmentDetails(uint256 investmentId_)
        internal
        view
        returns (SugarcaneLib.Investment memory)
    {
        return _investmentIdToDetails[investmentId_];
    }

    /**
     * @notice Combines the signer address and the investment index to create a unique id
     * @return returns the investment id
     */
    function investmentIdHash(address signerAddress_, uint256 investmentIndex_)
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (uint256)
    {
        return _addressAndNumberHash(signerAddress_, investmentIndex_);
    }

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
    ) external override whenNotPausedExceptAdmin onlySugarcaneManager {
        _addInvestment(
            signerAddress_,
            chainId_,
            protocolId_,
            initialAmountUsd_
        );
    }

    /**
     * @notice Adds the investment to the signer
     */
    function _addInvestment(
        address signerAddress_,
        uint256 chainId_,
        uint256 protocolId_,
        uint256 initialAmountUsd_
    ) internal {
        uint256 investmentIndex = _addressToInvestmentIds[signerAddress_]
            .length;

        // Create the investment id
        uint256 investmentId = _addressAndNumberHash(
            signerAddress_,
            investmentIndex
        );

        // Add the id to the list of investments that is user has
        uint256[] storage currentInvestmentListing = _addressToInvestmentIds[
            signerAddress_
        ];
        currentInvestmentListing.push(investmentId);

        // Add the investment details
        SugarcaneLib.Investment
            storage currentInvestment = _investmentIdToDetails[investmentId];
        currentInvestment.chainId = chainId_;
        currentInvestment.protocolId = protocolId_;
        currentInvestment.initialAmountUsd = initialAmountUsd_;
        currentInvestment.isActive = true;

        // Track specific protocol investment records
        uint256 addressWithProtocolId = _addressAndNumberHash(
            signerAddress_,
            protocolId_
        );
        uint256[]
            storage currentProtocolSpecificInvestmentListing = _specificProtocolInvestmentMap[
                addressWithProtocolId
            ];
        currentProtocolSpecificInvestmentListing.push(investmentId);

        emit InvestmentAdded(
            _msgSender(),
            signerAddress_,
            chainId_,
            protocolId_,
            investmentId,
            investmentIndex,
            currentProtocolSpecificInvestmentListing.length
        );
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[47] private __gap;
}
