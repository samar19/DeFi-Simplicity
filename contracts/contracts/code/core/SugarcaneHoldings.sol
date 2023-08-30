// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Local imports
import "../libs/SugarcaneLib.sol";

// Interface imports
import "../../interfaces/core/ISugarcaneHoldings.sol";
import "../utils/ManagerUtil.sol";

// The smart contract wallet that the signer controls on various chains
contract SugarcaneHoldings is ManagerUtil, ISugarcaneHoldings {
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //

    uint256 internal _signerChainId;
    address internal _signer;

    // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // // // // // // // // // //
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(
        address managerAddress_,
        uint256 signerChainId_,
        address signerAddress_
    ) initializer {
        __ManagerUtil_init(managerAddress_);

        _signerChainId = signerChainId_;
        _signer = signerAddress_;
    }

    // // // // // // // // // // // // // // // // // // // //
    // MODIFIERS
    // // // // // // // // // // // // // // // // // // // //

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends back the address of the signer of the holdings wallet
     * @return returns the address of the signer
     */
    function signer()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (address)
    {
        return _signer;
    }

    /**
     * @notice Sends back the chain id of the signer of the holdings wallet
     * @return returns the chain id of the signer
     */
    function signerChainId()
        external
        view
        override
        whenNotPausedExceptAdmin
        returns (uint256)
    {
        return _signerChainId;
    }

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    /*

    [WRITE] – bridgeUsd(uint256 destinationChain_, address signerAddress_, uint256 amount_)
    Sends the tokens to the destination chain

    [WRITE] – metaTransfer(address tokenAddress_, address toAddress_, uint256 amount_)
    A transaction where the gas was paid for by a separate party but the owner of the account is the only one that can move the assets

    [WRITE] – setSigner(uint256 chainId_, address signerAddress_)
    Sets the signer address and the chain id of the signer

    [WRITE] – transfer(address tokenAddress_, address toAddress_, uint256 amount_)
    Moves the amount of tokens from the holdings to the signer address
    */

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[48] private __gap;
}
