// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Overall imports
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

// Local imports
import "../utils/ManagerUtil.sol";

contract SugarcaneBadge is
    ERC1155Upgradeable,
    ERC1155SupplyUpgradeable,
    ManagerUtil
{
    // // // // // // // // // // // // // // // // // // // //
    // LIBRARIES AND STRUCTS
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

    using StringsUpgradeable for uint256;

    // // // // // // // // // // // // // // // // // // // //
    // VARIABLES - REMEMBER TO UPDATE __gap
    // // // // // // // // // // // // // // // // // // // //
    string private _uriPrefix;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address managerAddress_, string memory uriPrefix_)
        public
        initializer
    {
        __ManagerUtil_init(managerAddress_);
        _uriPrefix = uriPrefix_;

        __ERC1155_init("");
        __ERC1155Supply_init();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setURI(string memory newuri) public onlySugarcaneAdmin {
        string memory oldURI = _uriPrefix;
        _uriPrefix = newuri;

        emit UriPrefixUpdated(_msgSender(), oldURI, newuri);
    }

    function uri(uint256 badgeId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(_uriPrefix, badgeId.toHexString(), ".json")
            );
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155Upgradeable, ERC1155SupplyUpgradeable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 id,
    //     uint256 amount,
    //     bytes memory data
    // ) public virtual override {
    //   revert();
    // }

    function mint(
        address to,
        uint256 id,
        uint256 amount
    ) public onlySugarcaneManager {
        require(balanceOf(to, id) == 0, "Badge: Address has badge");
        _mint(to, id, amount, "");
    }

    // // // // // // // // // // // // // // // // // // // //
    // GAP
    // // // // // // // // // // // // // // // // // // // //

    // Gap for more space
    uint256[49] private __gap;
}
