// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {Endless} from "./Endless.sol";
import {EndlessProxy} from "./EndlessProxy.sol";


contract EndlessFactory is OwnableUpgradeable, UUPSUpgradeable {

  address public immutable implementation;
  address private _endlessCreateAddress;

  error AddressCannotBeZero();
  error InvalidCaller();


  modifier onlyEndlessCreateContract() { 
    if(_msgSender() != _endlessCreateAddress) revert InvalidCaller();
    _; 
  }

  constructor(address _implementation) initializer {
    if(_implementation == address(0)) revert AddressCannotBeZero();

    implementation = _implementation;
  }

  function initialize() external initializer {
    __Ownable_init();
    __UUPSUpgradeable_init();
  }

  function _authorizeUpgrade(address _newImplementation) internal override onlyOwner {}

  function createEndless(
    string memory endlessName,
    string memory endlessDescription,
    address initialOwner
  ) external onlyEndlessCreateContract returns (address newEndlessAddress) {
    EndlessProxy newEndless = new EndlessProxy(implementation, "");

    newEndlessAddress = address(newEndless);

    Endless(newEndlessAddress).initialize({
      _endlessName: endlessName,
      _endlessDescription: endlessDescription,
      _initialOwner: initialOwner
    });
  }

  function setEndlessCreateAddress(address endlessCreateAddress) external onlyOwner {
    if(endlessCreateAddress == address(0)) revert AddressCannotBeZero();

    _endlessCreateAddress = endlessCreateAddress;
  }
}
