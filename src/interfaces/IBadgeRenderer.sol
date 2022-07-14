// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

/// @title IBadgeRenderer
/// @author Huff Language Core Team
/// @author Modified from Jonathan Becker <jonathan@jbecker.dev> renoun <https://github.com/Jon-Becker/renoun>
interface IBadgeRenderer {
  function renderPullRequest(
    uint256 _pullRequestID,
    string calldata _pullRequestTitle,
    uint256 _additions,
    uint256 _deletions,
    string calldata _pullRequestCreatorPictureURL,
    string calldata _pullRequestCreatorUsername,
    string calldata _commitHash,
    string calldata _repositoryOwner,
    string calldata _repositoryName,
    uint256 _repositoryStars,
    uint256 _repositoryContributors
  ) external pure returns (string memory);
}
