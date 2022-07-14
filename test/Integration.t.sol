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
        // Validate Warden (aka admin)
        assertEq(shield.WARDEN(), address(this));

        // Verify Metadata
        assertEq(keccak256(abi.encode(shield.name())), keccak256(abi.encode("Huff Shield")));
        assertEq(keccak256(abi.encode(shield.symbol())), keccak256(abi.encode("HUFF")));

        // Total Supply should start at 0
        assertEq(shield.totalSupply(), 0);

        // Check repo name and org
        assertEq(keccak256(abi.encode(shield.REPO_NAME())), keccak256(abi.encode("huff-rs")));
        assertEq(keccak256(abi.encode(shield.REPO_OWNER())), keccak256(abi.encode("huff-language")));

        // Verify the Renderer Contract
        assertEq(shield.rendererContract(), address(renderer));

        // The repository stars and contributors should be set to 0 at first
        assertEq(shield.repositoryStars(), 0);
        assertEq(shield.repositoryContributors(), 0);
    }

    /// @notice Test Minting Tokens
    function testMint(address owner) public {
        // Can't transfer to the zero address
        vm.assume(owner != address(0));
        // Non-wardens can't mint
        vm.assume(owner != address(this));
        vm.startPrank(owner);
        vm.expectRevert(abi.encodeWithSignature("Unauthorized(address)", owner));
        shield.mint(
            owner,                                                // address _to,
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
        vm.stopPrank();

        // The warden can mint
        vm.startPrank(address(this));
        shield.mint(
            owner,                                                // address _to,
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
        vm.stopPrank();

        // Validate minting happened correctly
        assertEq(shield.totalSupply(), 1);
        assertEq(shield.balanceOf(owner), 1);
        assertEq(shield.balanceOf(address(this)), 0);
        assertEq(shield.repositoryStars(), 82);
        assertEq(shield.repositoryContributors(), 8);

        // Validate the contribution object
        (
            uint256 prid,
            string memory title,
            uint256 additions,
            uint256 deletions,
            string memory creatorPictureURL,
            string memory creatorUsername,
            string memory commitHash
        ) = shield.contribution(1);
        assertEq(prid, 20);
        // assertEq(c._pullRequestTitle, "feat(huff_lexer): v0.3.0");
        assertEq(additions, 211);
        assertEq(deletions, 79);
        // assertEq(c._pullRequestCreatorPictureURL, "https://avatars.githubusercontent.com/u/21288394?v=4");
        // assertEq(c._pullRequestCreatorUsername, "abigger87");
        // assertEq(c._commitHash, "df7b71b35a54641d09818a54e9a2e15d40e5e3a0");

        // Check zero pr ids revert
        vm.startPrank(address(this));
        vm.expectRevert(abi.encodeWithSignature("ZeroPullRequestID()"));
        shield.mint(
            owner,                                                // address _to,
            0,                                                      // uint256 _pullRequestID,
            "feat(huff_lexer): v0.3.0",                             // string memory _pullRequestTitle,
            211,                                                    // uint256 _additions,
            79,                                                     // uint256 _deletions,
            "https://avatars.githubusercontent.com/u/21288394?v=4", // string memory _pullRequestCreatorPictureURL,
            "abigger87",                                            // string memory _pullRequestCreatorUsername,
            "df7b71b35a54641d09818a54e9a2e15d40e5e3a0",             // string memory _commitHash,
            82,                                                     // uint256 _repositoryStars,
            8                                                       // uint256 _repositoryContributors
        );
        vm.stopPrank();
    }
}