// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {Endless} from "./Endless.sol";


contract EndlessFactory {

  using Clones for address;

  address public immutable endlessImplementation;
  address private _endlessCreateAddress;

  address public owner;

  error AddressCannotBeZero();
  error InvalidCaller();
  error OnlyOwner();


  modifier onlyOwner() {
    if(msg.sender != owner) {
      revert OnlyOwner();
    }
    _;
  }

  modifier onlyEndlessCreateContract() { 
    if(msg.sender != _endlessCreateAddress) revert InvalidCaller();
    _; 
  }

  constructor(address _implementation) {
    if(_implementation == address(0)) revert AddressCannotBeZero();

    endlessImplementation = _implementation;
  }


  function deployEndless(
    string memory endlessName,
    string memory endlessDescription,
    address initialOwner
  ) external onlyEndlessCreateContract returns (address) {
    address _newEndless = endlessImplementation.clone();

    Endless(_newEndless).initialize({
      _endlessName: endlessName,
      _endlessDescription: endlessDescription,
      _initialOwner: initialOwner
    });

    return _newEndless;
  }

  function setEndlessCreateAddress(address endlessCreateAddress) external onlyOwner {
    if(endlessCreateAddress == address(0)) revert AddressCannotBeZero();

    _endlessCreateAddress = endlessCreateAddress;
  }
}
