const Redistribute = artifacts.require("Redistribute");
const Idea = artifacts.require("Idea");
const ROOT_IDEA = require("../migrations/conf");

// Creates a new DAO, effectively resetting state for the test.
const withBlankDAO = () => Idea.new(ROOT_IDEA.name, ROOT_IDEA.ticker, ROOT_IDEA.shares, ROOT_IDEA.detailsIpfsID);

// Check that an idea's coins can be redistributed among x accounts
contract("Redistribute", async accounts => {
	it("should redistribute tokens among beneficiaries", async () => {
		const benefic = accounts.slice(5);

		const multi = await Redistribute.new(benefic);
		const juris = await withBlankDAO();

		// Spread n shares among 5 accounts
		await juris.transfer(multi.address, ROOT_IDEA.shares);
		await multi.releaseFunds(juris.address);

		assert.equal((await juris.balanceOf(benefic[1])).toString(), (ROOT_IDEA.shares / 5).toString());
	});
});
