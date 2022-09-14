// SPDX-License-Identifier: MIT

import "../Idea.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity ^0.8.11;

/**
 * Redistributes all ERC-20's incoming to the contract to specified
 * beneficiaries.
 */
contract Redistribute {
	/* To split between */
	address[] public beneficiaries;

	constructor(address[] memory _beneficiaries) {
		for (uint256 i = 0; i < _beneficiaries.length; i++) {
			beneficiaries.push(_beneficiaries[i]);
		}
	}

	/**
	 * Distributes the accumulated funds among the users.
	 */
	function releaseFunds(address token) external {
		IERC20 tokenContract = IERC20 (token);
		uint256 toDistribute = tokenContract.balanceOf(address(this)) / beneficiaries.length;

		for (uint256 i = 0; i < beneficiaries.length; i++) {
			require(tokenContract.transfer(beneficiaries[i], toDistribute), "Failed to fund beneficiary.");
		}
	}
}
