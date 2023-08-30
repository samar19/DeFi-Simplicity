// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Imports
// import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";

// Local imports
import "../libs/SugarcaneLib.sol";

// Interface imports
import "../../interfaces/core/ISugarcaneOnboardExecuteReceiverBase.sol";
import "../utils/ManagerUtil.sol";

// AxelarExecutable,
abstract contract SugarcaneOnboardExecuteReceiverBase is
    ManagerUtil,
    ISugarcaneOnboardExecuteReceiverBase
{
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //

    uint256 private __chainId;

    // Axelar specific variables
    address private __gateway;

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //

    function __SugarcaneOnboardExecuteReceiverBase_init(
        uint256 chainId_,
        address gateway_,
        address managerAddress_
    ) internal initializer {
        __chainId = chainId_;
        __gateway = gateway_;

        __ManagerUtil_init(managerAddress_);
    }

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

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

    function gateway() external view override returns (IAxelarGateway) {
        return _gateway();
    }

    function _gateway() internal view returns (IAxelarGateway) {
        return IAxelarGateway(_gatewayAddress());
    }

    /**
     * @notice Sends back the address of the bridge gateway
     * @return returns the address of the bridge gateway
     */
    function _gatewayAddress() internal view returns (address) {
        return __gateway;
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    // PULLING FROM AXELAR
    function executeWithToken(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) external override whenNotPausedExceptAdmin {}

    // PULLING FROM AXELAR
    function execute(
        bytes32 commandId,
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) external override whenNotPausedExceptAdmin {
        bytes32 payloadHash = keccak256(payload);

        if (
            !_gateway().validateContractCall(
                commandId,
                sourceChain,
                sourceAddress,
                payloadHash
            )
        ) revert NotApprovedByGateway();

        _execute(sourceChain, sourceAddress, payload);
    }

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal virtual {}

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

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[49] private __gap;
}
