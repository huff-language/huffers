// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {Shield} from "src/Shield.sol";
import {BadgeRenderer} from "src/BadgeRenderer.sol";

contract IntegrationTests is Test {
    using stdStorage for StdStorage;

    Shield shield;
    BadgeRenderer renderer;

    /// @notice Deploy the contracts
    function setUp() public {
        renderer = new BadgeRenderer();
        shield = new Shield(address(renderer));
    }

    /// @notice Validate the shield owner
    function testSetup() public {
        assertEq(shield.WARDEN(), address(this));
        assertEq(keccak256(abi.encode(shield.name())), keccak256(abi.encode("Huff Shield")));
        assertEq(keccak256(abi.encode(shield.symbol())), keccak256(abi.encode("HUFF")));
        assertEq(shield.totalSupply(), 0);
    }

}