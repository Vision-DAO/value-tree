// SPDX-License-Identifier: MIT

import "./Idea.sol";

pragma solidity ^0.8.11;

/**
 * A wrapper for the Idea contract used for centralizing events emitted by the
 * child contract.
 */
contract Factory {
	/* A user created an instance of the Idea contract. */
	event IdeaCreated(address idea);

	constructor() public {}

	function createIdea(string memory ideaName, string memory ideaTicker, uint256 ideaShares, string memory datumIpfsHash) external {
		Idea created = new Idea(ideaName, ideaTicker, ideaShares, datumIpfsHash);

		// Notify listeners, and transfer to msg.sender, because the registry is msg.sender
		emit IdeaCreated(address(created));
		require(created.transfer(msg.sender, ideaShares), "Failed to allocate supply.");
	}
}
