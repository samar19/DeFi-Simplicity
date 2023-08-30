// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {IAxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";
import "../utils/IManagerUtil.sol";

// The contract on the secondary chains that updates the manager
interface ISugarcaneOnboardExecuteReceiverBase is
    IAxelarExecutable,
    IManagerUtil
{
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when the gateway address is updated
     * @param admin The admin that made the update
     * @param chainId The chain id of the chain this is deployed on
     * @param oldGateway The old gateway address
     * @param newGateway The new gateway address
     */
    event GatewayUpdated(
        address indexed admin,
        uint256 chainId,
        address indexed oldGateway,
        address indexed newGateway
    );

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends the chain id
     * @return returns the number that represents the chain id
     */
    function chainId() external view returns (uint256);

    function gateway() external view override returns (IAxelarGateway);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    // PULLING FROM AXELAR
    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external override;

    // PULLING FROM AXELAR
    function executeWithToken(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) external override;

    /**
     * @notice Sets the address of the bridge gateway
     * @param gateway_ the address of the bridge gateway
     */
    function setGateway(address gateway_) external;
}
