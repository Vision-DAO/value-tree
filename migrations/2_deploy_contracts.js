const Factory = artifacts.require("Factory");
const Dao = artifacts.require("Idea");
const Prop = artifacts.require("Prop");
const ROOT_IDEA = require("./conf");

const ipfs = require("ipfs-core");

module.exports = function (deployer) {
    deployer.deploy(Factory);
	deployer.deploy(Dao, ROOT_IDEA.name, ROOT_IDEA.ticker, ROOT_IDEA.shares, ROOT_IDEA.detailsIpfsID);
	deployer.deploy(Prop, ...ROOT_IDEA.propArgs);
};
