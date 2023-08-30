// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

library SugarcaneLib {
    // Organized this way for variable packing
    struct Action {
        string[] variables;
        uint256 chainId;
        address functionSignature;
    }

    struct ChainAddressPair {
        uint256 chainId;
        address chainAddress;
    }

    struct OnboardAccountDetail {
        uint256 onboardingIndex;
        uint256 onboardedBlock;
        uint64 timestamp;
        address holdings;
        bool isOnboarded;
    }

    struct HoldingsToSigner {
        address signer;
        bool isOnboarded;
    }

    struct Investment {
        uint256 chainId;
        uint256 protocolId;
        uint256 initialAmountUsd;
        bool isActive;
    }

    struct SecondaryHoldings {
        uint256 chainId;
        address holdingsAddress;
        bool isSet;
    }

    struct SecondaryManager {
        uint256 chainId;
        address managerAddress;
        bool isSet;
    }
}
