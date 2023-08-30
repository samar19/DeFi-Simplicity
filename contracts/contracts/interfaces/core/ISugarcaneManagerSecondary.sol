// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";

import "./ISugarcaneManagerBase.sol";

//  The manager on a non-canonical chain
interface ISugarcaneManagerSecondary is ISugarcaneManagerBase {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //
    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Returns the execute onboard receiver address
     */
    function executeOnboardReceiver() external view returns (address);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sets the address of the execute Onboard Receiver
     * @param executeOnboardReceiver_ the address of the execute Onboard Receiver
     */
    function setExecuteOnboardReceiver(address executeOnboardReceiver_)
        external;
}
