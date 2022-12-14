const HelloWorld = artifacts.require("HelloWorld");

module.exports = function name(deployer) {
  deployer.deploy(HelloWorld);
};
