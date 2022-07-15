// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

// Raw imports to prevent pragma footguns
import 'forge-std/Script.sol';
import "src/Shield.sol";
import "src/BadgeRenderer.sol";

/// @notice A script to mint a shield token to clabby
contract MintSMN is Script {

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
          0xEd6C38A5e307D59DAed4593A85E62171F526E0Bd,             // address _to,
          55,                                                     // uint256 _pullRequestID,
          "Fixing lexer token character consumption",             // string memory _pullRequestTitle,
          42,                                                     // uint256 _additions,
          8,                                                      // uint256 _deletions,
          "https://avatars.githubusercontent.com/u/3140080?v=4",  // string memory _pullRequestCreatorPictureURL,
          "Saw-mon-and-Natalie",                                  // string memory _pullRequestCreatorUsername,
          "baf8290c2eab525acf1f5c11a8b693912bc52356",             // string memory _commitHash,
          83,                                                     // uint256 _repositoryStars,
          8                                                       // uint256 _repositoryContributors
      );
      vm.stopBroadcast();
    }

  }
}
