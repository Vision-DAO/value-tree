// SPDX-License-Identifier: MIT

import "./governance/Funding.sol";
import "./governance/Prop.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity ^0.8.11;

/* Represents the governance contract / semi-fungible NFT of an idea in the
 * value tree. */
contract Idea is ERC20 {
	/* Funding rates for derivative ideas */
	mapping (address => FundingRate) public fundedIdeas;

	/* Ideas connected to the current idea */
	address[] public children;

	/* The location of the idea on IPFS */
	string public ipfsAddr;

	/* The idea, and its datum have been committed to the blockchain. */
	event IdeaRecorded(string ipfsAddr);

	/* A child idea has had a new funds rate finalized. */
	event IdeaFunded(address idea, FundingRate rate);

	/* An instance of a child's funding has been released. */
	event FundingDispersed(address idea, FundingRate rate);

	// Ensures that the given address is a funded child idea
	modifier isChild(address child) {
		FundingRate memory rate = fundedIdeas[child];

		// The specified contract must be a child that is funded by this governing contract
		require(rate.value > 0, "Proposal doesn't allocate any funds");

		_;
	}

	/**
	 * Creates a new idea from the given datum stored on IPFS, and idea token attributes.
	 */
	constructor(string memory ideaName, string memory ideaTicker, uint256 ideaShares, string memory datumIpfsHash) ERC20(ideaName, ideaTicker) {
		_mint(msg.sender, ideaShares);
		ipfsAddr = datumIpfsHash;

		emit IdeaRecorded(datumIpfsHash);
	}

	/**
	 * Finalizes the given proposition if it has past its expiry date.
	 */
	function finalizeProp(Prop proposal) external {
		require(block.timestamp >= proposal.expiresAt(), "Vote has not yet terminated.");
		require(balanceOf(address(proposal)) * 100 / totalSupply() > 50, "Proposal rejected: failed to obtain majority.");

		// Calculate the final funds rate before reverting all token votes
		FundingRate memory finalRate = proposal.finalFundsRate();

		// Votes for the funds rate are weighted based on balances of this governing
		// token
		finalRate.value /= (5 + (finalRate.expiry - block.timestamp) * 10 / finalRate.intervalLength) / 10;

		// Refund all voters - this must be completed before the vote can be terminated
		require(proposal.refundAll(), "Failed to refund all voters");

		// Record the new funds rate
		address toFund = proposal.toFund();

		// Add the funded idea to the list of children if it hasn't been seen before, and
		// remove the child once its funding is nonexistent
		if (fundedIdeas[toFund].value == 0) {
			children.push(toFund);
		} else if (finalRate.value == 0) {
			for (uint256 i = 0; i < children.length; i++) {
				if (children[i] == toFund) {
					children[i] = children[children.length - 1];
					children.pop();

					break;
				}
			}
		}

		fundedIdeas[toFund] = finalRate;
		emit IdeaFunded(toFund, finalRate);
	}

	/**
	 * Disperses funding to the calling Idea, if it is a child in the
	 * jurisdiction of the current token, and has funds to be allocated.
	 */
	function disperseFunding(address idea) external isChild(idea) {
		FundingRate memory rate = fundedIdeas[idea];

		require(rate.expiry > block.timestamp, "Funding has expired");
		require(block.timestamp - rate.lastClaimed >= rate.intervalLength, "Claimed too recently");

		fundedIdeas[idea].lastClaimed = block.timestamp;

		// The number of tokens to disperse
		uint256 tokens = rate.value;

		// The governing contract has to have funds left in the designated token to transfer to the child
		// The idea can be rewarded in ETH or an ERC-20
		address thisAddr = address(this);

		if (fundedIdeas[idea].token == address(0x00)) {
			require(thisAddr.balance >= rate.value, "Not enough ETH for designated funds");

			(bool sent, ) = payable(idea).call{value: tokens}("");

			require(sent, "Failed to disperse ETH rewards");
		} else {
			// If the reward is in our own token, mint it
			if (rate.kind == FundingType.MINT) {
				require(rate.token == thisAddr, "Cannot mint funds for a foreign token");

				_mint(idea, tokens);
			} else {
				require(IERC20 (rate.token).transfer(idea, tokens), "Failed to disperse ERC rewards");
			}
		}

		emit FundingDispersed(idea, rate);
	}

	/**
	 * Gets the number of children funded by the idea.
	 */
	function numChildren() external view returns (uint256) {
		return children.length;
	}
}
