// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";

import {EndlessCreate} from "./EndlessCreate.sol";


contract Endless is ERC721Upgradeable, UUPSUpgradeable {

  uint256 private _tokenId;
  uint256 private _maxSupply;

  EndlessCreate private _endlessCreateAddress;

  IMetadataRenderer metadataRenderer;

  error NonexistentToken();


  function initialize(
    string memory _endlessName,
    string memory _endlessDescription,
    address _initialOwner
  ) public initializer {
    __ERC721_init(_endlessName, _endlessDescription);

    _maxSupply = 10;
  }

  function _authorizeUpgrade(address _newImplementation) internal override {}


  function mint() external returns (uint256) {


    unchecked {
      _mint(_msgSender(), _tokenId++);
    }

    address endlessAddress = EndlessCreate(_endlessCreateAddress).createNewEndless("", "", _msgSender());
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {

    if(!_exists(tokenId)) {
      revert NonexistentToken();
    }

    return metadataRenderer.tokenURI(tokenId);
  }

}
