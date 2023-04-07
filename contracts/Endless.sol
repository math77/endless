// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;


import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";


import {EndlessCreate} from "./EndlessCreate.sol";
import {OwnableSkeleton} from "./OwnableSkeleton.sol";


contract Endless is ERC721Upgradeable, ReentrancyGuardUpgradeable, OwnableSkeleton {

  uint256 private _tokenId;
  uint256 private constant MAX_SUPPLY = 10;

  struct EndlessData {
    address owner;
    address endlessAddress;
  }

  IMetadataRenderer public renderer;
  EndlessCreate private _endlessCreateAddress;

  mapping(uint256 tokenId => EndlessData endlessData) public endlessDataToTokenId;

  

  error NonexistentToken();
  error NotContractOwner();
  error SupplySoldOut();


  modifier onlyOwner() { 
    if(owner() != _msgSender()) revert NotContractOwner(); 
    _; 
  }
  

  function initialize(
    string memory _endlessName,
    string memory _endlessDescription,
    address _initialOwner
  ) external initializer {

    __ERC721_init(_endlessName, _endlessDescription);
    __ReentrancyGuard_init();

    _setOwner(_initialOwner);
  }


  function mint() external nonReentrant {

    if(_tokenId == MAX_SUPPLY) revert SupplySoldOut();

    unchecked {
      _mint(msg.sender, _tokenId++);
    }

    address endlessAddress = EndlessCreate(_endlessCreateAddress).createNewEndless("", "", _msgSender());

    endlessDataToTokenId[_tokenId] = EndlessData({
      owner: msg.sender,
      endlessAddress: endlessAddress
    });
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {

    if(!_exists(tokenId)) {
      revert NonexistentToken();
    }

    return renderer.tokenURI(tokenId);
  }

  function setEndlessCreateAddress(EndlessCreate endlessCreateAddress) external onlyOwner {
    _endlessCreateAddress = endlessCreateAddress;
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 /*batchSize*/) internal virtual override {
    if(from != address(0)) {

      endlessDataToTokenId[tokenId].owner = to;

      address contractAddr = endlessDataToTokenId[tokenId].endlessAddress;

      Endless(contractAddr).setNewOwner(to);
    }
  }

  function setNewOwner(address newOwner) external onlyOwner {
    _setOwner(newOwner);
  }

}
