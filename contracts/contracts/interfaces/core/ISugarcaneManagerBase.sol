// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";
import "../utils/ISugarcaneCore.sol";

//  Abstract class that the managers on primary and secondary chains will inherit
interface ISugarcaneManagerBase is ISugarcaneCore {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when account has been onboarded
     * @param onboarder The onboarder that onboarded the signer account
     * @param chainId The chain id of the chain this is deployed on
     * @param signerAccount The address of the signer account
     * @param holdingsAddress The address of the holdings account
     */
    event AccountOnboarded(
        address indexed onboarder,
        uint256 chainId,
        address indexed signerAccount,
        address indexed holdingsAddress
    );

    /**
     * @notice Emitted when the execute onboard receiver address is updated
     * @param admin The admin that made the update
     * @param chainId The chain id of the chain this is deployed on
     * @param oldExecuteOnboardReceiver The old execute onboard receiver address
     * @param newExecuteOnboardReceiver The new execute onboard receiver address
     */
    event ExecuteOnboardReceiverUpdated(
        address indexed admin,
        uint256 chainId,
        address indexed oldExecuteOnboardReceiver,
        address indexed newExecuteOnboardReceiver
    );

    /**
     * @notice Emitted when the gas service address is updated
     * @param admin The admin that made the update
     * @param chainId The chain id of the chain this is deployed on
     * @param oldGasService The old gas service address
     * @param newGasService The new gas service address
     */
    event GasServiceUpdated(
        address indexed admin,
        uint256 chainId,
        address indexed oldGasService,
        address indexed newGasService
    );

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

    /**
     * @notice Emitted when the onboarder address is updated
     * @param admin The admin that made the update
     * @param chainId The chain id of the chain this is deployed on
     * @param oldOnboarder The old onboarder address
     * @param newOnboarder The new onboarder address
     */
    event OnboarderUpdated(
        address indexed admin,
        uint256 chainId,
        address indexed oldOnboarder,
        address indexed newOnboarder
    );

    /**
     * @notice Emitted when the sugarcane factory address is updated
     * @param admin The admin that made the update
     * @param chainId The chain id of the chain this is deployed on
     * @param oldSugarcaneFactory The old Sugarcane Factory address
     * @param newSugarcaneFactory The new Sugarcane Factory address
     */
    event SugarcaneFactoryUpdated(
        address indexed admin,
        uint256 chainId,
        address indexed oldSugarcaneFactory,
        address indexed newSugarcaneFactory
    );

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sends the chain id
     * @return returns the number that represents the chain id
     */
    function chainId() external view returns (uint256);

    /**
     * @notice Sends back the address of the bridge gateway
     * @return returns the address of the bridge gateway
     */
    function bridgeGateway() external view returns (address);

    /**
     * @notice Sends back the address of the bridge gas service
     * @return returns the address of the bridge gas service
     */
    function bridgeGasService() external view returns (address);

    /**
     * @notice Sends back the address of the Sugarcane factory
     */
    function sugarcaneFactory() external view returns (address);

    /**
     * @notice Sends the array of onboarded addresses
     * @return returns the array of onboarded addresses
     */
    function onboardedAddresses() external view returns (address[] memory);

    /**
     * @notice Returns the address that can onboard signers (on Base this is the Base relayer, on Goerli it is the defender address, and on the other chains it is their Sugarcane_Onboard_Executor)
     */
    function onboarder() external view returns (address);

    /**
     * @notice Tells if the signer has onboarded
     */
    function hasOnboarded(address signerAddress_) external view returns (bool);

    /**
     * @notice Gets all the onboard details of this signer on this chain
     */
    function onboardDetails(address signerAddress_)
        external
        view
        returns (SugarcaneLib.OnboardAccountDetail memory);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Sets the address of the bridge gas service
     * @param gasService_ the address of the bridge gas service
     */
    function setGasService(address gasService_) external;

    /**
     * @notice Sets the address of the bridge gateway
     * @param gateway_ the address of the bridge gateway
     */
    function setGateway(address gateway_) external;

    /**
     * @notice Sets the address of the Sugarcane Factory
     * @param sugarcaneFactory_ the address of the Sugarcane Factory
     */
    function setSugarcaneFactory(address sugarcaneFactory_) external;

    /**
     * @notice Called to onboard an account
     * @param signerAddress_ the address of the account to onboard
     */
    function onboardAccount(address signerAddress_) external;

    /**
     * @notice Updates the valid onboarding address contract
     * @param onboarder_ the address of the onboarder
     */
    function setOnboarder(address onboarder_) external;
}
