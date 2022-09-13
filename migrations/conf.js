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

	propArgs: ["Test proposal", "0x928613da9dE038458c29fe34066fbbDe74A2DB9f", "0x928613da9dE038458c29fe34066fbbDe74A2DB9f", "0x928613da9dE038458c29fe34066fbbDe74A2DB9f", 1, 0, "QmVzRraiBep2wzVYUKdLTPhDCdfSAPtU8VgKTgTQAxTX6v", 1],

	redistArgs: ["0xcde398fe14f86c4dbf0b053f7add78da85820d6d", ["0xd3fe8b4f1cf50e27fe8707921d38b77f09ac6db8", "0xe7fbee6f331e209a6c4b2b1f8eb382d54f438b76", "0xc32dc5713162479dfd0e0b7e54780dcf23a58fc7", "0xc3df0b130ecab8d0d836cfbd9b08dc4856fe6563", "0xdc36fa7961324b2403e4dd8b9c3bdd27c725e693", "0x9405c86c9021f068b5d2a7a6a818c34a85252f23", "0xCf457e101EF999C95c6563A494241D9C0aD8763B"]];
};

