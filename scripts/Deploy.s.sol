// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {Script} from 'forge-std/Script.sol';

/// @notice A Deployment Script
contract Deploy is Script {

  /// @notice The main script entrypoint
  function run(address governance, address treasury) external returns (ScriptTypes.Contracts memory contracts) {
      require(governance != address(0), "Governance address not set!");
      require(treasury != address(0), "Treasury address not set!");

      vm.startBroadcast();

  }
}
