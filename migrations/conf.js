const BigNumber = require("bignumber.js");

/* Attributes of the root node in the idea tree used for deployment */
module.exports = {
	name: "Vision DAO",
	ticker: "VIS",

	// One per student, with 18 decimals of precision
	shares: new BigNumber("13e18"),

	// Hard-coded address of the details of this idea on IPFS (an HTML file)
	// containing an overview of the concept (static/index.html)
	detailsIpfsID: "QmVzRraiBep2wzVYUKdLTPhDCdfSAPtU8VgKTgTQAxTX6v",

	propArgs: ["Test proposal", "0x928613da9dE038458c29fe34066fbbDe74A2DB9f", "0x928613da9dE038458c29fe34066fbbDe74A2DB9f", "0x928613da9dE038458c29fe34066fbbDe74A2DB9f", 1, 0, 0, 0, "QmVzRraiBep2wzVYUKdLTPhDCdfSAPtU8VgKTgTQAxTX6v", 1],
};

