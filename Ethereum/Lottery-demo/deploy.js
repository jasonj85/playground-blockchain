const HdWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const { interface, bytecode } = require("./compile");

// development only account. No money here lol!
const provider = new HdWalletProvider(
  "rumble degree toward target wet garden old female father suspect pilot result",
  "https://rinkeby.infura.io/v3/1ffa3ece1b524421aaf8f4da341730b4"
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log("Attempting to deploy from account", accounts[0]);

  const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ gas: "1000000", from: accounts[0] });

  console.log("Contract deployed to: ", result.options.address);
  console.log("Interface: ", interface);
  provider.engine.stop();
};
deploy();
