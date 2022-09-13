// SPDX-License-Identifier: MIT

import "../Idea.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity ^0.8.11;

/**
 * Redistributes all ERC-20's incoming to the contract to specified
 * beneficiaries.
 */
contract Redistribute {
	/* To split between */
	address[] public beneficiaries;
	address token;

	constructor(address token, string[] memory _beneficiaries) {
		this.beneficiaries = _beneficiaries;
	}

	/**
	 * Distributes the accumulated funds among the users.
	 */
	function releaseFunds() external {
		IERC20 tokenContract = IERC20 (token);
		uint256 toDistribute = 1 / beneficiaries.length * tokenContract.balanceOf(address(this));

		for (uint256 i = 0; i < beneficiaries.length; i++) {
			require(tokenContract.transfer(beneficiaries[i], toDistribute), "Failed to fund beneficiary.");
		}
	}
}
