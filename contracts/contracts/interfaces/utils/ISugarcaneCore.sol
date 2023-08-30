// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol";

// Moved the boilerplate code to a separate contract that can be imported
interface ISugarcaneCore is IAccessControlUpgradeable {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Pause the address store
     */
    function pause() external;

    /**
     * @notice Unpause the address store
     */
    function unpause() external;
}
