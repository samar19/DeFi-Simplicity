// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Libraries
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

// Local imports
import "../libs/StringOperations.sol";
import "../libs/SugarcaneLib.sol";

// Interface imports
import "./SugarcaneManagerBase.sol";
import "../../interfaces/core/ISugarcaneManagerPrimary.sol";

//  The manager on the canonical chain
contract SugarcaneManagerPrimary is
    SugarcaneManagerBase,
    ISugarcaneManagerPrimary
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

    mapping(uint256 => SugarcaneLib.SecondaryManager)
        private __secondaryManagerDetails;

    mapping(uint256 => SugarcaneLib.SecondaryHoldings)
        private __secondaryChainHoldings;

    uint256[] private __setChains;

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

        __SugarcaneManagerPrimary_init_unchained();
    }

    function __SugarcaneManagerPrimary_init_unchained() internal initializer {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Throws if message sender is not the onboard execute receiver contract.
     */
    modifier onlyOnboardExecuteReceiver() {
        require(
            __executeOnboardReceiver == _msgSender(),
            "ManagerBase: not onboard execute"
        );
        _;
    }

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
     * @notice Returns the execute onboard receiver address
     */
    function secondaryChainHoldingAddress(address address_, uint256 chainId_)
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (SugarcaneLib.SecondaryHoldings memory)
    {
        return _secondaryChainHoldingAddress(address_, chainId_);
    }

    /**
     * @notice Returns the execute onboard receiver address
     */
    function _secondaryChainHoldingAddress(address address_, uint256 chainId_)
        internal
        view
        returns (SugarcaneLib.SecondaryHoldings memory)
    {
        return
            __secondaryChainHoldings[_addressAndNumberHash(address_, chainId_)];
    }

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

    /**
     * @notice Returns the secondary manager details
     */
    function secondaryManager(uint256 chainId_)
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (SugarcaneLib.SecondaryManager memory)
    {
        return _secondaryManager(chainId_);
    }

    /**
     * @notice Returns the secondary manager details
     */
    function _secondaryManager(uint256 chainId_)
        internal
        view
        returns (SugarcaneLib.SecondaryManager memory)
    {
        return __secondaryManagerDetails[chainId_];
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
     * @notice Sets the address of the manager on a different chain
     * @param secondaryManager_ the address of the manager on mumbai
     */
    function setSecondaryManager(uint256 chainId_, address secondaryManager_)
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneAdmin
    {
        _setSecondaryManager(chainId_, secondaryManager_);
    }

    /**
     * @notice Sets the address of the manager on mumbai
     * @param secondaryManager_ the address of the manager on mumbai
     */
    function _setSecondaryManager(uint256 chainId_, address secondaryManager_)
        internal
    {
        SugarcaneLib.SecondaryManager
            storage currentSecondaryManager = __secondaryManagerDetails[
                chainId_
            ];

        if (!currentSecondaryManager.isSet) {
            currentSecondaryManager.chainId = chainId_;
            currentSecondaryManager.isSet = true;
        }

        address oldSecondaryManagerAddress = __secondaryManagerDetails[chainId_]
            .managerAddress;
        currentSecondaryManager.managerAddress = secondaryManager_;

        emit SecondaryManagerUpdated(
            _msgSender(),
            _chainId(),
            chainId_,
            oldSecondaryManagerAddress,
            secondaryManager_
        );
    }

    /**
     * @notice Does checks for valid request and talks to Sugarcane_Factory to create Holdings address
     * @param signerAddress_ the address of the account to onboard
     */
    function onboardAccount(address signerAddress_)
        external
        override(ISugarcaneManagerBase, SugarcaneManagerBase)
        nonReentrant
        whenNotPausedExceptAdmin
        onlyOnboarder
    {
        // Run onboard locally
        _onboardAccount(signerAddress_);

        // Onboard on mumbai
        _crossChainOnboardInitiate(
            CHAIN_ID_MUMBAI,
            CHAIN_NAME_MUMBAI,
            signerAddress_
        );

        // Onboard on arbitrum
        // _crossChainOnboardInitiate(CHAIN_ID_ARBITRUM_GOERLI, CHAIN_NAME_ARBITRUM_GOERLI, signerAddress_);

        nonce = nonce + 1;
    }

    /**
     * @notice Does checks for valid request and talks to Sugarcane_Factory to create Holdings address
     * @param chainId_ the id of the chain to onboard the signer on
     * @param chainName_  the name of the chain to onboard the signer on
     * @param signerAddress_ the address of the account to onboard
     */
    function _crossChainOnboardInitiate(
        uint256 chainId_,
        string memory chainName_,
        address signerAddress_
    ) internal {
        uint256 nonce_ = nonce;
        bytes memory modifiedPayload = abi.encode(nonce_, signerAddress_);

        // Send a message to the secondary chain to continue onboarding
        _axelarGateway().callContract(
            // string memory destinationChain,
            chainName_,
            // string memory contractAddress,
            string(
                abi.encodePacked(_secondaryManager(chainId_).managerAddress)
            ),
            // bytes memory payload
            modifiedPayload
        );
    }

    /**
     * @notice This is a function only the Sugarcane_Onboard_Execute_Receiver_Primary contract can change it is
     */
    function addSecondaryChainHoldingAddress(
        uint256 secondaryChainId_,
        address signerAddress_,
        address secondaryChainHoldingsAddress_
    ) external override whenNotPausedExceptAdmin onlyOnboardExecuteReceiver {
        _addSecondaryChainHoldingAddress(
            secondaryChainId_,
            signerAddress_,
            secondaryChainHoldingsAddress_
        );
    }

    /**
     * @notice This is a function only the Sugarcane_Onboard_Execute_Receiver_Primary contract can change it is
     */
    function _addSecondaryChainHoldingAddress(
        uint256 secondaryChainId_,
        address signerAddress_,
        address secondaryChainHoldingsAddress_
    ) internal {
        SugarcaneLib.SecondaryHoldings
            storage currentSecondaryHoldings = __secondaryChainHoldings[
                _addressAndNumberHash(signerAddress_, secondaryChainId_)
            ];

        currentSecondaryHoldings.chainId = secondaryChainId_;
        currentSecondaryHoldings
            .holdingsAddress = secondaryChainHoldingsAddress_;
        currentSecondaryHoldings.isSet = true;

        emit AddedSecondaryChainHoldingAddress(
            _msgSender(),
            _chainId(),
            secondaryChainId_,
            signerAddress_,
            secondaryChainHoldingsAddress_
        );
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[45] private __gap;
}
