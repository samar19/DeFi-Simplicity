// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library StringOperations {
    function toUint256(string memory s) internal pure returns (uint256, bool) {
        bool hasError = false;
        bytes memory b = bytes(s);
        uint256 result = 0;
        uint256 oldResult = 0;
        for (uint256 i = 0; i < b.length; i++) {
            if (uint8(b[i]) >= 48 && uint8(b[i]) <= 57) {
                // Store old value so we can check for overflows
                oldResult = result;
                result = result * 10 + (uint8(b[i]) - 48);

                // Prevent overflows
                if (oldResult > result) {
                    // Result overflowed and is smaller than last stored value
                    hasError = true;
                }
            } else {
                hasError = true;
            }
        }
        return (result, hasError);
    }

    function len(string memory str) internal pure returns (uint256 length) {
        uint256 i = 0;
        bytes memory string_rep = bytes(str);

        while (i < string_rep.length) {
            if (uint8(string_rep[i]) >> 7 == 0) i += 1;
            else if (uint8(string_rep[i]) >> 5 == 0x6) i += 2;
            else if (uint8(string_rep[i]) >> 4 == 0xE) i += 3;
            else if (uint8(string_rep[i]) >> 3 == 0x1E)
                i += 4;
                //For safety
            else i += 1;

            length++;
        }
    }
}
