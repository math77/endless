// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";


import {EndlessCreate} from "./EndlessCreate.sol";


contract EndlessOriginPoint is ERC721 {

  uint256 private _tokenId;

  struct EndlessData {
    address owner;
    address endlessAddress;
  }

  EndlessCreate private _endlessCreateAddress;

  mapping(uint256 tokenId => EndlessData endlessInfo) private _endlessDataToTokenId; 

  error NonexistentToken();
  

  constructor() ERC721("", "") {}


  function mint() external payable returns (uint256) {

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

}
