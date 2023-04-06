// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {EndlessDataStorage} from "./EndlessDataStorage.sol";
import {EndlessCreate} from "./EndlessCreate.sol";
import {Endless} from "./Endless.sol";


contract EndlessOriginPoint is ERC721, ReentrancyGuard, Ownable, EndlessDataStorage {

  uint256 private _tokenId;
  uint256 private constant MAX_SUPPLY = 10;

  EndlessCreate private _endlessCreateAddress;

  error NonexistentToken();
  error SupplySoldOut();
  

  constructor(Endless endlessAddress) ERC721("EndlessOriginPoint", "ENDLESSOP") Ownable() {}


  function mint() external payable nonReentrant {

    if(_tokenId == MAX_SUPPLY) revert SupplySoldOut();

    unchecked {
      _mint(msg.sender, _tokenId++);
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

}
