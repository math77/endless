// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {EndlessCreate} from "./EndlessCreate.sol";


contract EndlessOriginPoint is ERC721, ReentrancyGuard, Ownable {

  uint256 private _tokenId;
  uint256 private constant MAX_SUPPLY = 10;

  struct EndlessData {
    address owner;
    address endlessAddress;
  }

  EndlessCreate private _endlessCreateAddress;

  mapping(uint256 tokenId => EndlessData endlessData) private _endlessDataToTokenId; 

  error NonexistentToken();
  error SupplySoldOut();
  

  constructor() ERC721("EndlessOriginPoint", "ENDLESSOP") Ownable() {}


  function mint() external payable nonReentrant returns (uint256) {

    if(_tokenId == MAX_SUPPLY) revert SupplySoldOut();

    unchecked {
      _mint(msg.sender, _tokenId++);
    }

    address endlessAddress = EndlessCreate(_endlessCreateAddress).createNewEndless("", "", _msgSender());

    _endlessDataToTokenId[_tokenId] = EndlessData({
      owner: _msgSender(),
      endlessAddress: endlessAddress
    });
  }

  function tokenURI(uint256 tokenId) public view override returns (string memory) {

    if(!_exists(tokenId)) {
      revert NonexistentToken();
    }

    return "";
  }

  function setEndlessCreateAddress(EndlessCreate endlessCreateAddress) external onlyOwner {
    _endlessCreateAddress = endlessCreateAddress;
  }

}
