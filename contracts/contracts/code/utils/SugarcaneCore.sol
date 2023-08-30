// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Contracts
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

// Libraries
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeCastUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

// Local imports
import "../libs/StringOperations.sol";

// Interface imports
import "../../interfaces/utils/ISugarcaneCore.sol";

// Moved the boilerplate code to a separate contract that can be imported
abstract contract SugarcaneCore is
    Initializable,
    ContextUpgradeable,
    AccessControlUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable,
    ISugarcaneCore
{
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    using AddressUpgradeable for address payable;
    using SafeCastUpgradeable for uint256;
    using SafeMathUpgradeable for uint256;
    using StringsUpgradeable for uint256;
    using StringOperations for string;

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //
    // Roles
    bytes32 public constant SUGARCANE_ADMIN_ROLE =
        keccak256("SUGARCANE_ADMIN_ROLE");

    // Badge Ids
    uint256 public constant BADGE_ID_LIQUIDITY_PROVIDER =
        uint256(keccak256("badge.LIQUIDITY_PROVIDER"));
    uint256 public constant BADGE_ID_STAKER =
        uint256(keccak256("badge.STAKER"));
    uint256 public constant BADGE_ID_LENDER =
        uint256(keccak256("badge.LENDER"));
    uint256 public constant BADGE_ID_FRIEND_REFER =
        uint256(keccak256("badge.FRIEND_REFER"));
    uint256 public constant BADGE_ID_INVEST_ONE =
        uint256(keccak256("badge.INVEST_ONE"));
    uint256 public constant BADGE_ID_INVEST_FIVE =
        uint256(keccak256("badge.INVEST_FIVE"));
    uint256 public constant BADGE_ID_INVEST_TEN =
        uint256(keccak256("badge.INVEST_TEN"));

    // Protocol Ids
    uint256 public constant PROTOCOL_ID_AAVE =
        uint256(keccak256("protocol.AAVE"));
    uint256 public constant PROTOCOL_ID_UNISWAP =
        uint256(keccak256("protocol.UNISWAP"));
    uint256 public constant PROTOCOL_ID_SSV_LIQUID_STAKING =
        uint256(keccak256("protocol.SSV_LIQUID_STAKING"));

    // Chain Ids
    uint256 public constant CHAIN_ID_ARBITRUM_GOERLI = 421613;
    uint256 public constant CHAIN_ID_BASE_GOERLI = 84531;
    uint256 public constant CHAIN_ID_GOERLI = 1; // 5;
    uint256 public constant CHAIN_ID_MUMBAI = 137; // 80001;

    // Chain Names
    string public constant CHAIN_NAME_ARBITRUM_GOERLI = "arbitrum";
    string public constant CHAIN_NAME_BASE_GOERLI = "...";
    string public constant CHAIN_NAME_GOERLI = "Ethereum"; // "ethereum-2";
    string public constant CHAIN_NAME_MUMBAI = "Polygon";

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Initializes the contract.
     */
    function __SugarcaneCore_init() internal initializer {
        __Context_init();
        __AccessControl_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        __UUPSUpgradeable_init();

        // Set up access control for the initializing contract
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(SUGARCANE_ADMIN_ROLE, _msgSender());

        _pause();

        __SugarcaneCore_init_unchained();
    }

    function __SugarcaneCore_init_unchained() internal initializer {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Throws if message sender called by any account other than a Sugarcane admin.
     */
    modifier onlySugarcaneAdmin() {
        _checkRole(SUGARCANE_ADMIN_ROLE, _msgSender());
        _;
    }

    /**
     * @notice To make a function callable only when the contract is not paused.
     *
     * Requirements:
     * - The contract must not be paused.
     */
    modifier whenNotPausedExceptAdmin() {
        if (!hasRole(SUGARCANE_ADMIN_ROLE, _msgSender())) {
            require(!paused(), "SugarcaneCore: paused");
        }
        _;
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    /**
     * [UPGRADABILITY]
     * @notice The function that supports new implementation contracts
     * @param newImplementation The new implementation contract
     */
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlySugarcaneAdmin
    {}

    /**
     * @notice Pauses the Sugarcane contract
     */
    function pause() external override onlySugarcaneAdmin {
        _pause();
    }

    /**
     * @notice Unpauses the Sugarcane contract
     */
    function unpause() external override onlySugarcaneAdmin {
        _unpause();
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[50] private __gap;
}
