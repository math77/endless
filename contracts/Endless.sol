// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import {EndlessCreate} from "./EndlessCreate.sol";
import {EndlessDataStorage} from "./EndlessDataStorage.sol";
import {OwnableSkeleton} from "./OwnableSkeleton.sol";


contract Endless is ERC721Upgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable, OwnableSkeleton, EndlessDataStorage {

  uint256 private _tokenId;
  uint256 private _maxSupply;

  EndlessCreate private _endlessCreateAddress;

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
  ) public initializer {
    __ERC721_init(_endlessName, _endlessDescription);
    __ReentrancyGuard_init();

    _setOwner(_initialOwner);

    _maxSupply = 10;
  }

  function _authorizeUpgrade(address _newImplementation) internal override {}


  function mint() external nonReentrant {

    if(_tokenId == _maxSupply) revert SupplySoldOut();

    unchecked {
      _mint(_msgSender(), _tokenId++);
    }

    address endlessAddress = EndlessCreate(_endlessCreateAddress).createNewEndless("", "", _msgSender());

    endlessDataToTokenId[_tokenId] = EndlessData({
      owner: _msgSender(),
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
