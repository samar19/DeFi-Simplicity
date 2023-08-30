// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Libraries
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeCastUpgradeable.sol";

// Local imports
import "../libs/SugarcaneLib.sol";

// Interface imports
import "../../interfaces/core/ISugarcaneFactory.sol";
import "../../interfaces/core/ISugarcaneManagerBase.sol";
import "../utils/SugarcaneCore.sol";

//  Abstract class that the managers on primary and secondary chains will inherit
abstract contract SugarcaneManagerBase is SugarcaneCore, ISugarcaneManagerBase {
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //
    using SafeCastUpgradeable for uint256;

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //

    uint256 private __chainId;
    address private __onboarder;
    address private __sugarcaneFactory;

    // Axelar specific variables
    address private __gateway;
    address private __gasService;

    // Map the signer to the holdings
    mapping(address => SugarcaneLib.OnboardAccountDetail)
        internal _addressOnboardMap;

    // Map the holdings account to the signer
    mapping(address => SugarcaneLib.HoldingsToSigner)
        internal _holdingsToSignerMap;

    // List of all onboarded addresses
    address[] private __onboardedAddresses;

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //
    function __SugarcaneManagerBase_init(
        uint256 chainId_,
        address gateway_,
        address gasService_
    ) internal initializer {
        __SugarcaneCore_init();

        __chainId = chainId_;
        __gateway = gateway_;
        __gasService = gasService_;
    }

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Throws if message sender is not the onboarder.
     */
    modifier onlyOnboarder() {
        require(__onboarder == _msgSender(), "ManagerBase: not onboarder");
        _;
    }

    // // // // // // // // // // // // // // // // // // // //
    // AXELAR SPECIFIC FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends back the wrapped Axelar gateway object
     * @return returns the Axelar gateway object
     */
    function _axelarGateway() internal view returns (IAxelarGateway) {
        return IAxelarGateway(_bridgeGateway());
    }

    /**
     * @notice Sends back the wrapped Axelar gas service object
     * @return returns the Axelar gas service object
     */
    function _axelarGasService() internal view returns (IAxelarGasService) {
        return IAxelarGasService(_bridgeGasService());
    }

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //
    /**
     * @notice Sends the chain id
     * @return returns the number that represents the chain id
     */
    function chainId()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (uint256)
    {
        return _chainId();
    }

    /**
     * @notice Sends the chain id
     * @return returns the number that represet
     */
    function _chainId() internal view returns (uint256) {
        return __chainId;
    }

    /**
     * @notice Sends back the address of the bridge gateway
     * @return returns the address of the bridge gateway
     */
    function bridgeGateway()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address)
    {
        return _bridgeGateway();
    }

    /**
     * @notice Sends back the address of the bridge gateway
     * @return returns the address of the bridge gateway
     */
    function _bridgeGateway() internal view returns (address) {
        return __gateway;
    }

    /**
     * @notice Sends back the address of the bridge gas service
     * @return returns the address of the bridge gas service
     */
    function bridgeGasService()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address)
    {
        return _bridgeGasService();
    }

    /**
     * @notice Sends back the address of the bridge gas service
     * @return returns the address of the bridge gas service
     */
    function _bridgeGasService() internal view returns (address) {
        return __gasService;
    }

    /**
     * @notice Sends back the address of the Sugarcane factory
     */
    function sugarcaneFactory()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address)
    {
        return _sugarcaneFactory();
    }

    /**
     * @notice Sends back the address of the Sugarcane factory
     */
    function _sugarcaneFactory() internal view returns (address) {
        return __sugarcaneFactory;
    }

    /**
     * @notice Sends the array of onboarded addresses
     * @return returns the array of onboarded addresses
     */
    function onboardedAddresses()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address[] memory)
    {
        return _onboardedAddresses();
    }

    /**
     * @notice Sends the array of onboarded addresses
     * @return returns the array of onboarded addresses
     */
    function _onboardedAddresses() internal view returns (address[] memory) {
        return __onboardedAddresses;
    }

    /**
     * @notice Returns the address that can onboard signers (on Base this is the Base relayer, on Goerli it is the defender address, and on the other chains it is their Sugarcane_Onboard_Executor)
     */
    function onboarder()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address)
    {
        return _onboarder();
    }

    /**
     * @notice Returns the address that can onboard signers (on Base this is the Base relayer, on Goerli it is the defender address, and on the other chains it is their Sugarcane_Onboard_Executor)
     */
    function _onboarder() internal view returns (address) {
        return __onboarder;
    }

    /**
     * @notice Tells if the signer has onboarded
     */
    function hasOnboarded(address signerAddress_)
        external
        view
        override
        returns (bool)
    {
        return _hasOnboarded(signerAddress_);
    }

    /**
     * @notice Tells if the signer has onboarded
     */
    function _hasOnboarded(address signerAddress_)
        internal
        view
        returns (bool)
    {
        return _addressOnboardMap[signerAddress_].isOnboarded;
    }

    /**
     * @notice Gets all the onboard details of this signer on this chain
     */
    function onboardDetails(address signerAddress_)
        external
        view
        override
        returns (SugarcaneLib.OnboardAccountDetail memory)
    {
        return _onboardDetails(signerAddress_);
    }

    /**
     * @notice Gets all the onboard details of this signer on this chain
     */
    function _onboardDetails(address signerAddress_)
        internal
        view
        returns (SugarcaneLib.OnboardAccountDetail memory)
    {
        return _addressOnboardMap[signerAddress_];
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sets the address of the bridge gas service
     * @param gasService_ the address of the bridge gas service
     */
    function setGasService(address gasService_)
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneAdmin
    {
        _setGasService(gasService_);
    }

    /**
     * @notice Sets the address of the bridge gas service
     * @param gasService_ the address of the bridge gas service
     */
    function _setGasService(address gasService_) internal {
        address oldGasService = __gasService;
        __gasService = gasService_;

        emit GasServiceUpdated(
            _msgSender(),
            _chainId(),
            oldGasService,
            gasService_
        );
    }

    /**
     * @notice Sets the address of the bridge gateway
     * @param gateway_ the address of the bridge gateway
     */
    function setGateway(address gateway_)
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneAdmin
    {
        _setGateway(gateway_);
    }

    /**
     * @notice Sets the address of the bridge gateway
     * @param gateway_ the address of the bridge gateway
     */
    function _setGateway(address gateway_) internal {
        address oldGateway = __gateway;
        __gateway = gateway_;

        emit GatewayUpdated(_msgSender(), _chainId(), oldGateway, gateway_);
    }

    /**
     * @notice Sets the address of the Sugarcane Factory
     * @param sugarcaneFactory_ the address of the Sugarcane Factory
     */
    function setSugarcaneFactory(address sugarcaneFactory_)
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneAdmin
    {
        _setSugarcaneFactory(sugarcaneFactory_);
    }

    /**
     * @notice Sets the address of the Sugarcane Factory
     * @param sugarcaneFactory_ the address of the Sugarcane Factory
     */
    function _setSugarcaneFactory(address sugarcaneFactory_) internal {
        address oldSugarcaneFactory = __sugarcaneFactory;
        __sugarcaneFactory = sugarcaneFactory_;

        emit SugarcaneFactoryUpdated(
            _msgSender(),
            _chainId(),
            oldSugarcaneFactory,
            sugarcaneFactory_
        );
    }

    /**
     * @notice Does checks for valid request and talks to SugarcaneFactory to create Holdings address
     * @param signerAddress_ the address of the account to onboard
     */
    function onboardAccount(address signerAddress_)
        external
        virtual
        override
        nonReentrant
        whenNotPausedExceptAdmin
        onlyOnboarder
    {
        _onboardAccount(signerAddress_);
    }

    /**
     * @notice Does checks for valid request and talks to SugarcaneFactory to create Holdings address
     * @param signerAddress_ the address of the account to onboard
     */
    function _onboardAccount(address signerAddress_) internal {
        // Only onboard accounts who have not onboarded
        require(
            !_addressOnboardMap[signerAddress_].isOnboarded,
            "ManagerBase: Account onboarded"
        );

        // Add the investment details
        SugarcaneLib.OnboardAccountDetail
            storage currentSignerAccount = _addressOnboardMap[signerAddress_];

        currentSignerAccount.onboardedBlock = block.number;
        currentSignerAccount.timestamp = block.timestamp.toUint64();
        currentSignerAccount.isOnboarded = true;
        currentSignerAccount.onboardingIndex = __onboardedAddresses.length;

        // Add the address to the list of onboarded addresses
        __onboardedAddresses.push(signerAddress_);

        address holdingsAddress = ISugarcaneFactory(__sugarcaneFactory)
            .createHoldingsAccount(_chainId(), signerAddress_);

        // Update the reference of the signer address to the holdings address
        currentSignerAccount.holdings = holdingsAddress;

        // Also do a reverse mapping of the holdings address to the signer address
        SugarcaneLib.HoldingsToSigner
            storage reverseMapping = _holdingsToSignerMap[holdingsAddress];

        reverseMapping.signer = signerAddress_;
        reverseMapping.isOnboarded = true;

        emit AccountOnboarded(
            _msgSender(),
            _chainId(),
            signerAddress_,
            holdingsAddress
        );
    }

    /**
     * @notice Updates the valid onboarding address contract
     * @param onboarder_ the address of the onboarder
     */
    function setOnboarder(address onboarder_)
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneAdmin
    {
        _setOnboarder(onboarder_);
    }

    /**
     * @notice Updates the valid onboarding address contract
     * @param onboarder_ the address of the onboarder
     */
    function _setOnboarder(address onboarder_) internal {
        address oldOnboarder = __onboarder;
        __onboarder = onboarder_;

        emit OnboarderUpdated(
            _msgSender(),
            _chainId(),
            oldOnboarder,
            onboarder_
        );
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[42] private __gap;
}
