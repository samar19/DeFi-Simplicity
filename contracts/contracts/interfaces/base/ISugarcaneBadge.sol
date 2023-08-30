// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Overall imports
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

// Connected parts of the system
import "../../code/libs/SugarcaneLib.sol";
import "../utils/IManagerUtil.sol";

// The badge interface
interface ISugarcaneBadge is IERC1155Upgradeable, IManagerUtil {
    // // // // // // // // // // // // // // // // // // // //
    // EVENTS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * @notice Emitted when the uri prefix has been changed
     * @param admin The admin that made the update
     * @param oldUriPrefix The old uri prefix
     * @param newUriPrefix The new uri prefix
     */
    event UriPrefixUpdated(
        address indexed admin,
        string oldUriPrefix,
        string newUriPrefix
    );

    // // // // // // // // // // // // // // // // // // // //
    // GETTERS
    // // // // // // // // // // // // // // // // // // // //

    /**
     * TAKEN FROM ERC1155SupplyUpgradeable
     * @dev Total amount of tokens in with a given id.
     */
    function totalSupply(uint256 id) external view returns (uint256);

    /**
     * TAKEN FROM ERC1155SupplyUpgradeable
     * @dev Indicates whether any token exist with a given id, or not.
     */
    function exists(uint256 id) external view returns (bool);

    // // // // // // // // // // // // // // // // // // // //
    // CORE FUNCTIONS
    // // // // // // // // // // // // // // // // // // // //
    function supportsInterface(bytes4 interfaceId)
        external
        view
        override
        returns (bool);

    function setURI(string memory newuri) external;

    function uri(uint256 badgeId) external view returns (string memory);

    /**
     * @dev Mints a badge id to user
     */
    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) external;
}
