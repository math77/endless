pragma solidity 0.8.18;

import {IMetadataRenderer} from "./interfaces/IMetadataRenderer.sol";

contract EndlessDataStorage {

  uint256 public tokenId;

  struct EndlessData {
    address owner;
    address endlessAddress;
  }

  IMetadataRenderer public renderer;

  mapping(uint256 tokenId => EndlessData endlessData) public endlessDataToTokenId;
}
