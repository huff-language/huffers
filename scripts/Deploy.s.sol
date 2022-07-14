// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import {Script} from 'forge-std/Script.sol';

/// @notice A very simple deployment script
contract Deploy is Script {

  /// @notice The main script entrypoint
  /// @return shield The deployed shield contract
  function run() external returns (Shield shield) {
    vm.startBroadcast();
    BadgeRenderer renderer = new BadgeRenderer();
    shield = new Shield(renderer);
    vm.stopBroadcast();
  }
}
