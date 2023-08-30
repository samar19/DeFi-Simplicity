// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Local imports

// Interface imports
import "../../interfaces/utils/IManagerUtil.sol";
import "./SugarcaneCore.sol";

// The abstract contract that handles the setting and retrieval of the manager details
abstract contract ManagerUtil is SugarcaneCore, IManagerUtil {
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //

    address private __manager;

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Initializes the contract.
     */
    function __ManagerUtil_init(address managerAddress_) internal initializer {
        __SugarcaneCore_init();
        __manager = managerAddress_;

        __ManagerUtil_init_unchained();
    }

    function __ManagerUtil_init_unchained() internal initializer {}

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Throws if message sender called by any account other than the manager contract.
     */
    modifier onlySugarcaneManager() {
        require(__manager == _msgSender(), "ManagerUtil: not manager");
        _;
    }

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Get the address of the manager
     * @return returns the address of the manager
     */
    function manager()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address)
    {
        return _manager();
    }

    /**
     * @notice Get the address of the manager
     * @return returns the address of the manager
     */
    function _manager() internal view returns (address) {
        return __manager;
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    /**
     * @notice Updates the manager contract location
     */
    function setManager(address managerAddress_)
        external
        override
        whenNotPausedExceptAdmin
        onlySugarcaneAdmin
    {
        _setManager(managerAddress_);
    }

    /**
     * @notice Updates the manager contract location
     */
    function _setManager(address managerAddress_) internal {
        address oldManagerAddress = __manager;
        __manager = managerAddress_;

        emit ManagerUpdated(_msgSender(), oldManagerAddress, managerAddress_);
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[49] private __gap;
}
