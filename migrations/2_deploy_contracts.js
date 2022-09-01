const Factory = artifacts.require("Factory");
const Dao = artifacts.require("Idea");
const Prop = artifacts.require("Prop");
const ROOT_IDEA = require("./conf");

const ipfs = require("ipfs-core");

module.exports = async function (deployer) {
	await deployer.deploy(Factory);
	const registry = await Factory.deployed();

	await deployer.deploy(Dao, ROOT_IDEA.name, ROOT_IDEA.ticker, ROOT_IDEA.shares, ROOT_IDEA.detailsIpfsID);

	// Register the new DAO as a DAO under the registry
	await registry.createIdea(ROOT_IDEA.name, ROOT_IDEA.ticker, ROOT_IDEA.shares, ROOT_IDEA.detailsIpfsID);
	await deployer.deploy(Prop, ...ROOT_IDEA.propArgs);
};
