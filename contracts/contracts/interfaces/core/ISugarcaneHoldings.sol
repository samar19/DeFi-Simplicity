// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";
import "../utils/IManagerUtil.sol";

// The smart contract wallet that the signer controls on various chains
interface ISugarcaneHoldings is IManagerUtil {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //
    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends back the address of the signer of the holdings wallet
     * @return returns the address of the signer
     */
    function signer() external view returns (address);

    /**
     * @notice Sends back the chain id of the signer of the holdings wallet
     * @return returns the chain id of the signer
     */
    function signerChainId() external view returns (uint256);

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
}
