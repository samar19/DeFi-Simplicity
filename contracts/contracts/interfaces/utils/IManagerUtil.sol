// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./ISugarcaneCore.sol";

// The abstract contract that handles the setting and retrieval of the manager details
interface IManagerUtil is ISugarcaneCore {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when the manager is address is updated
     * @param sugarcaneAdmin The admin that made the update
     * @param oldManagerAddress The old manager address
     * @param newManagerAddress The new manager address
     */
    event ManagerUpdated(
        address indexed sugarcaneAdmin,
        address indexed oldManagerAddress,
        address indexed newManagerAddress
    );

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Get the address of the manager
     * @return returns the address of the manager
     */
    function manager() external view returns (address);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Updates the manager contract location
     */
    function setManager(address managerAddress_) external;
}
