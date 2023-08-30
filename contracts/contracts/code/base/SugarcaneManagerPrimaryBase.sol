// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Libraries
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

// Local imports
import "../libs/StringOperations.sol";
import "../libs/SugarcaneLib.sol";

// Interface imports
import "../../interfaces/base/ISugarcaneBadge.sol";
import "../../interfaces/base/ISugarcaneInvestmentRegistry.sol";
import "../../interfaces/base/ISugarcaneManagerPrimaryBase.sol";
import "../core/SugarcaneManagerBase.sol";

//  The manager on the canonical chain
contract SugarcaneManagerPrimaryBase is
    SugarcaneManagerBase,
    ISugarcaneManagerPrimaryBase
{
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    using SafeMathUpgradeable for uint256;
    using StringOperations for string;

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //

    address private __investmentRegistry;
    address private __sugarcaneBadge;

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    /**
     * @notice Initializes the contract.
     */
    function initialize(uint256 chainId_) public initializer {
        __SugarcaneManagerBase_init(chainId_, address(0), address(0));

        __SugarcaneManagerPrimaryBase_init_unchained();
    }

    function __SugarcaneManagerPrimaryBase_init_unchained()
        internal
        initializer
    {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends back the address of the badge
     */
    function sugarcaneBadge() external view override returns (address) {
        return __sugarcaneBadge;
    }

    /**
     * @notice Sends back the object of the badge
     * @return _sugarcaneBadge interactable contract
     */
    function _sugarcaneBadge() internal view returns (ISugarcaneBadge) {
        return ISugarcaneBadge(__sugarcaneBadge);
    }

    /**
     * @notice Sends back the address of the investment registry
     */
    function investmentRegistry() external view override returns (address) {
        return __investmentRegistry;
    }

    /**
     * @notice Sends back the object of the investment registry
     * @return _investmentRegistry interactable contract
     */
    function _investmentRegistry()
        internal
        view
        returns (ISugarcaneInvestmentRegistry)
    {
        return ISugarcaneInvestmentRegistry(__investmentRegistry);
    }

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
    ) external override nonReentrant onlySugarcaneAdmin {
        // Add the investment for this user
        _investmentRegistry().addInvestment(
            signerAddress_,
            chainId_,
            protocolId_,
            initialAmountUsd_
        );

        // Mint the badges
        // Get the number of investments for this signer
        uint256[] memory overallInvestmentListing = _investmentRegistry()
            .investments(signerAddress_);
        uint256[]
            memory protocolSpecificInvestmentListing = _investmentRegistry()
                .investmentsForProtocol(signerAddress_, protocolId_);

        // Check badges for overall usage
        if (overallInvestmentListing.length == 1) {
            // If this is the first investment mint the first badge
            _sugarcaneBadge().mint(signerAddress_, BADGE_ID_INVEST_ONE, 1);
        } else if (overallInvestmentListing.length == 5) {
            // If this is the fifth investment mint the fifth badge
            _sugarcaneBadge().mint(signerAddress_, BADGE_ID_INVEST_FIVE, 1);
        } else if (overallInvestmentListing.length == 10) {
            // If this is the tenth investment mint the tenth badge
            _sugarcaneBadge().mint(signerAddress_, BADGE_ID_INVEST_TEN, 1);
        }

        // Check for badges from investments in types of protocols
        if (protocolSpecificInvestmentListing.length == 1) {
            if (protocolId_ == PROTOCOL_ID_AAVE) {
                // If this is the first lending investment mint the first lending badge
                _sugarcaneBadge().mint(signerAddress_, BADGE_ID_LENDER, 1);
            } else if (protocolId_ == PROTOCOL_ID_SSV_LIQUID_STAKING) {
                // If this is the first staking investment mint the first staking badge
                _sugarcaneBadge().mint(signerAddress_, BADGE_ID_STAKER, 1);
            } else if (protocolId_ == PROTOCOL_ID_UNISWAP) {
                // If this is the first liquidity providing investment mint the first liquidity providing badge
                _sugarcaneBadge().mint(
                    signerAddress_,
                    BADGE_ID_LIQUIDITY_PROVIDER,
                    1
                );
            }
        }
    }

    /**
     * @notice Sets the address of the investment registry
     * @param investmentRegistry_ the address of the investment registry
     */
    function setInvestmentRegistry(address investmentRegistry_)
        external
        override
        onlySugarcaneAdmin
    {
        _setInvestmentRegistry(investmentRegistry_);
    }

    /**
     * @notice Sets the address of the investment registry
     * @param investmentRegistry_ the address of the investment registry
     */
    function _setInvestmentRegistry(address investmentRegistry_) internal {
        address oldInvestmentRegistry = __investmentRegistry;
        __investmentRegistry = investmentRegistry_;

        emit InvestmentRegistryUpdated(
            _msgSender(),
            oldInvestmentRegistry,
            investmentRegistry_
        );
    }

    /**
     * @notice Sets the address of the sugarcane badge
     * @param sugarcaneBadge_ the address of the sugarcane badge
     */
    function setSugarcaneBadge(address sugarcaneBadge_)
        external
        override
        onlySugarcaneAdmin
    {
        _setSugarcaneBadge(sugarcaneBadge_);
    }

    /**
     * @notice Sets the address of the sugarcane badge
     * @param sugarcaneBadge_ the address of the sugarcane badge
     */
    function _setSugarcaneBadge(address sugarcaneBadge_) internal {
        address oldSugarcaneBadge = __sugarcaneBadge;
        __sugarcaneBadge = sugarcaneBadge_;

        emit SugarcaneBadgeUpdated(
            _msgSender(),
            oldSugarcaneBadge,
            sugarcaneBadge_
        );
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[48] private __gap;
}
