// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;


import {EndlessFactory} from "./EndlessFactory.sol";


contract EndlessCreate {

  EndlessFactory private _endlessFactoryAddress;

  function createNewEndless(
    string memory endlessName, 
    string memory endlessDescription,
    address initialOwner
  ) external returns (address newEndlessAddress) {
    newEndlessAddress = EndlessFactory(_endlessFactoryAddress).createEndless(endlessName, endlessDescription, initialOwner);
  }

  function setEndlessFactoryAddress(EndlessFactory factoryAddr) external {
    require(address(factoryAddr) != address(0), "CANNOT BE ZERO ADDRESS");

    _endlessFactoryAddress = factoryAddr;
  }
}
