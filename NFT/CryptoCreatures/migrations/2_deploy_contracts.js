const CryptoCreatures = artifacts.require("CryptoCreatures");

module.exports = function(deployer) {
  deployer.deploy(CryptoCreatures);
};
