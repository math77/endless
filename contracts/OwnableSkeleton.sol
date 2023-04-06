// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


/*

from: https://github.com/ourzora/zora-drops-contracts/blob/main/src/utils/OwnableSkeleton.sol
modified

*/

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This ownership interface matches OZ's ownable interface.
 */
contract OwnableSkeleton {

  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  function owner() public view virtual returns (address) {
    return _owner;
  }

  function _setOwner(address newAddress) internal {
    emit OwnershipTransferred(_owner, newAddress);
    _owner = newAddress;
  }
}
