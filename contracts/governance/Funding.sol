// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

/* Funds can be designed to be spent from a treasury of saved funds in a
 * governance contract, or be designated to be minted. */
enum FundingType {
	TREASURY,
	MINT
}

struct FundingRate {
	/* The token used for funding. Null for ETH */
	address token;

	/* The number of tokens to be allocated in total */
	uint256 value;

	/* Whether the funds have been spent or not */
	bool spent;

	/* The manner by which the funding is executed */
	FundingType kind;
}
