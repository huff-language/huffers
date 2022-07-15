// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

// Raw imports to prevent pragma footguns
import 'forge-std/Script.sol';
import "src/Shield.sol";
import "src/BadgeRenderer.sol";

/// @notice A script to mint a shield token to clabby
contract MintClabby is Script {

  address constant RINKEBY_DEPLOYMENT_ADDRESS = 0xcE3a82dbf663D7C6e8C2Fc3E8a6DB42fC0739929;
  address constant OPTIMISM_DEPLOYMENT_ADDRESS = 0x9172C52bf412de76E080bd595f8f8c55f0ff867C;

  /// @notice The main script entrypoint
  /// @return shield The deployed shield contract
  function run() external returns (Shield shield) {
    uint256 size;
    assembly { size := extcodesize(OPTIMISM_DEPLOYMENT_ADDRESS) }
    if (size != 0) {
      vm.startBroadcast();
      shield = Shield(OPTIMISM_DEPLOYMENT_ADDRESS);
      shield.mint(
          0x5a9BE988c4a2B2CfF7F4d4982E096f6f2AB86c48,             // address _to,
          153,                                                    // uint256 _pullRequestID,
          "feat(huff_cli): Solidity interface generation",        // string memory _pullRequestTitle,
          160,                                                    // uint256 _additions,
          4,                                                      // uint256 _deletions,
          "https://avatars.githubusercontent.com/u/8406232?v=4",  // string memory _pullRequestCreatorPictureURL,
          "clabby",                                               // string memory _pullRequestCreatorUsername,
          "1c15df8d238fa33c0a1b84990c76b41a8831d5d3",             // string memory _commitHash,
          83,                                                     // uint256 _repositoryStars,
          8                                                       // uint256 _repositoryContributors
      );
      vm.stopBroadcast();
    }

  }
}

