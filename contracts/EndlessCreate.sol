// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;


import {EndlessFactory} from "./EndlessFactory.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract EndlessCreate is Ownable {

  EndlessFactory private _endlessFactoryAddress;

  constructor() Ownable() {}

  function createNewEndless(
    string memory endlessName, 
    string memory endlessDescription,
    address initialOwner
  ) external returns (address newEndlessAddress) {
    newEndlessAddress = EndlessFactory(_endlessFactoryAddress).deployEndless(endlessName, endlessDescription, initialOwner);
  }

  function setEndlessFactoryAddress(EndlessFactory factoryAddr) external onlyOwner {
    require(address(factoryAddr) != address(0), "CANNOT BE ZERO ADDRESS");

    _endlessFactoryAddress = factoryAddr;
  }
}
