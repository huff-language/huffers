// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

// Raw imports to prevent pragma footguns
import 'forge-std/Script.sol';
import "src/Shield.sol";
import "src/BadgeRenderer.sol";

/// @notice A script to mint a shield token
contract Mint is Script {

  address constant RINKEBY_DEPLOYMENT_ADDRESS = 0xcE3a82dbf663D7C6e8C2Fc3E8a6DB42fC0739929;
  address constant OPTIMISM_DEPLOYMENT_ADDRESS = 0x9172C52bf412de76E080bd595f8f8c55f0ff867C;
  address constant IMBUYING_ETH = 0x3FB7501f5e451509Da23aD25c331A0737ef514A2;

  /// @notice The main script entrypoint
  /// @return shield The deployed shield contract
  function run() external returns (Shield shield) {
    uint256 size;
    assembly { size := extcodesize(OPTIMISM_DEPLOYMENT_ADDRESS) }
    if (size != 0) {
      vm.startBroadcast();
      shield = Shield(OPTIMISM_DEPLOYMENT_ADDRESS);
      shield.mint(
          IMBUYING_ETH,                                           // address _to,
          20,                                                     // uint256 _pullRequestID,
          "feat(huff_lexer): v0.3.0",                             // string memory _pullRequestTitle,
          211,                                                    // uint256 _additions,
          79,                                                     // uint256 _deletions,
          "https://avatars.githubusercontent.com/u/21288394?v=4", // string memory _pullRequestCreatorPictureURL,
          "abigger87",                                            // string memory _pullRequestCreatorUsername,
          "df7b71b35a54641d09818a54e9a2e15d40e5e3a0",             // string memory _commitHash,
          82,                                                     // uint256 _repositoryStars,
          8                                                       // uint256 _repositoryContributors
      );
      vm.stopBroadcast();
    }

  }
}

