const CreateNFT = artifacts.require("CreateNFT");

module.exports = function name(deployer) {
  deployer.deploy(CreateNFT);
};
