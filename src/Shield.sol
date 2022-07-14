// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import './base64.sol';
import {ERC721} from "solmate/tokens/ERC721.sol";
import {IBadgeRenderer} from "src/interfaces/IBadgeRenderer.sol";

/// @title Shield
/// @author Huff Language Core Team
/// @notice A contribution badge for Huff Language GitHub Contributors
/// @author Modified from Jonathan Becker <jonathan@jbecker.dev> renoun <https://github.com/Jon-Becker/renoun>
contract Shield is ERC721 {

  /// ----------------------------------------------------
  /// Custom Errors
  /// ----------------------------------------------------

  /// @notice The caller is not authorized on this func
  error Unauthorized(address caller);

  /// @notice The PR ID is zero
  error ZeroPullRequestID();

  /// @notice Attempt to transfer the token
  error NonTransferrable();

  /// @notice A non-existant token
  error TokenDoesNotExist();

  /// ----------------------------------------------------
  /// Public Config
  /// ----------------------------------------------------

  /// @notice The repository owner
  string public constant REPO_OWNER = "huff-language";

  /// @notice The repository name
  string public constant REPO_NAME = "huffers";

  /// @notice The admin address
  address public immutable WARDEN;

  /// @notice The render contract address
  address public rendererContract;

  /// @notice The total suppy
  uint256 public totalSupply;

  /// @notice The number of repository stars
  uint256 public repositoryStars;

  /// @notice The number of repository contributors
  uint256 public repositoryContributors;

  /// @notice A contribution object
  struct Contribution {
    uint256 _pullRequestID;
    string _pullRequestTitle;
    uint256 _additions;
    uint256 _deletions;
    string _pullRequestCreatorPictureURL;
    string _pullRequestCreatorUsername;
    string _commitHash;
  }

  /// @notice Maps token id to a contribution
  mapping(uint256 => Contribution) public contribution;

  /// ----------------------------------------------------
  /// CONSTRUCTOR
  /// ----------------------------------------------------

  constructor(address renderer) ERC721("Huff Shield", "HUFF") {
    WARDEN = msg.sender;
    rendererContract = renderer;
  }

  /// ----------------------------------------------------
  /// MINTING LOGIC
  /// ----------------------------------------------------

  /// @notice Mints a new GitHub contribition badge
  /// @param _to The address to mint the badge to
  /// @param _pullRequestID The ID of the pull request
  /// @param _pullRequestTitle The title of the pull request
  /// @param _additions The number of additions in the pull request
  /// @param _deletions The number of deletions in the pull request
  /// @param _pullRequestCreatorPictureURL The URL of the pull request creator's profile picture
  /// @param _pullRequestCreatorUsername The username of the pull request creator
  /// @param _commitHash The hash of the commit
  /// @param _repositoryStars The number of stars the repository has
  /// @param _repositoryContributors The number of contributors to the repository
  /// @return True if minted
  function mint(
    address _to,
    uint256 _pullRequestID,
    string memory _pullRequestTitle,
    uint256 _additions,
    uint256 _deletions,
    string memory _pullRequestCreatorPictureURL,
    string memory _pullRequestCreatorUsername,
    string memory _commitHash,
    uint256 _repositoryStars,
    uint256 _repositoryContributors
  ) public virtual {
    // Validation Logic
    if (msg.sender != WARDEN) revert Unauthorized(msg.sender);
    if (_pullRequestID == 0) revert ZeroPullRequestID();

    // Update the repository stars and contributors
    repositoryStars = _repositoryStars;
    repositoryContributors = _repositoryContributors;

    // Create a contribution
    Contribution memory _contribution = Contribution(
      _pullRequestID,
      _pullRequestTitle,
      _additions,
      _deletions,
      _pullRequestCreatorPictureURL,
      _pullRequestCreatorUsername,
      _commitHash
    );

    // Increment the total supply
    totalSupply++;

    // Mint to the address
    _mint(_to, totalSupply);

    // Update the contribution object
    contribution[totalSupply] = _contribution;
  }

  /// ----------------------------------------------------
  /// NON TRANSFERRABILITY OVERRIDES
  /// ----------------------------------------------------

  /// @notice Overrides the transferFrom function to make this token non-transferrable
  function transferFrom(address, address, uint256) public override {
    revert NonTransferrable();
  }

  /// @notice Overrides the approvals since the token is non-transferrable
  function approve(address, uint256) public override {
    revert NonTransferrable();
  }

  /// @notice Overrides setting approvals since the token is non-transferrable
  function setApprovalForAll(address operator, bool approved) public override {
    revert NonTransferrable();
  }

  /// ----------------------------------------------------
  /// ADMIN FUNCTIONALITY
  /// ----------------------------------------------------

  /// @notice Switches the rendering contract
  /// @param _newRenderer The new rendering contract
  function changeRenderer(address _newRenderer) public {
    // Validation Logic
    if (msg.sender != WARDEN) revert Unauthorized(msg.sender);
    if (_newRenderer == address(0)) revert ZeroAddress();

    // Update the contract
    rendererContract = _newRenderer;
  }

  /// ----------------------------------------------------
  /// VISIBILITY
  /// ----------------------------------------------------

  /// @notice Switches the rendering contract
  /// @param _tokenId The token ID to render
  /// @return The token URI of the token ID
  function tokenURI(uint256 _tokenId) public override view virtual returns (string memory) {
    if (ownerOf[_tokenId] == address(0)) revert TokenDoesNotExist();

    Contribution memory _contribution = contribution[_tokenId];
    string memory json = Base64.encode(bytes(string(abi.encodePacked(
      '{',
      '"name": "Pull Request #',_integerToString(_contribution._pullRequestID),'",',
      '"description": "A shiny, non-transferrable badge to show off my GitHub contribution.",',
      '"tokenId": ',_integerToString(_tokenId),',',
      '"image": "data:image/svg+xml;base64,',Base64.encode(bytes(_renderSVG(_contribution))),'"',
      '}'
      ))));

    return string(abi.encodePacked('data:application/json;base64,', json));
  }

  /// ----------------------------------------------------
  /// HELPER FUNCTIONS
  /// ----------------------------------------------------

  /// @notice Converts an integer to a string
  /// @param  _i The integer to convert
  /// @return The string representation of the integer
  function _integerToString(uint256 _i) internal pure returns (string memory) {
    if (_i == 0) return "0";

    uint256 j = _i;
    uint256 len;
    while (j != 0) {
      len++;
      j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint256 k = len;
    while (_i != 0) {
      k = k-1;
      uint8 temp = (48 + uint8(_i - _i / 10 * 10));
      bytes1 b1 = bytes1(temp);
      bstr[k] = b1;
      _i /= 10;
    }
    return string(bstr);
  }

  function _renderSVG(Contribution memory _contribution) internal view returns (string memory){
    IBadgeRenderer renderer = IBadgeRenderer(rendererContract);
    return renderer.renderPullRequest(
      _contribution._pullRequestID,
      _contribution._pullRequestTitle,
      _contribution._additions,
      _contribution._deletions,
      _contribution._pullRequestCreatorPictureURL,
      _contribution._pullRequestCreatorUsername,
      _contribution._commitHash,
      REPO_OWNER,
      REPO_NAME,
      repositoryStars,
      repositoryContributors
    );
  }
}
