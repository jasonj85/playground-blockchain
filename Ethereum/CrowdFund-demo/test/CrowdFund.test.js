const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());

const compiledFactory = require("../ethereum/build/CrowdFundFactory.json");
const compiledCrowdFund = require("../ethereum/build/CrowdFund.json");

let factory;
let accounts;
let crowdFund;
let crowdFundAddress;

beforeEach(async () => {
  accounts = await web3.eth.getAccounts();

  factory = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({ data: compiledFactory.bytecode })
    .send({ from: accounts[0], gas: "1000000" });

  await factory.methods.createCrowdFund("100").send({
    from: accounts[0],
    gas: "1000000",
  });

  [crowdFundAddress] = await factory.methods.getDeployedCrowdFunds().call();

  crowdFund = await new web3.eth.Contract(
    JSON.parse(compiledCrowdFund.interface),
    crowdFundAddress
  );
});

describe("CrowdFunds", () => {
  it("deploys the factory and crowdfund", () => {
    assert.ok(factory.options.address);
    assert.ok(crowdFund.options.address);
  });

  it("caller is the crowd fund manager", async () => {
    const manager = await crowdFund.methods.manager().call();
    assert.equal(accounts[0], manager);
  });

  it("allows ppl to contribute money & marks them as approvers", async () => {
    const manager = await crowdFund.methods.contribute().send({
      value: "500",
      from: accounts[1],
    });

    const isContributer = await crowdFund.methods.approvers(accounts[1]).call();
    assert(isContributer);
  });

  it("requires a min contribution", async () => {
    try {
      await crowdFund.methods.contribute().send({
        value: "5",
        from: accounts[1],
      });

      assert(false);
    } catch (error) {
      assert(error);
    }
  });

  it("allows a manager to make a payment requets", async () => {
    await crowdFund.methods
      .createRequest("Buy metal", "223", accounts[1])
      .send({
        from: accounts[0],
        gas: "1000000",
      });

    const req = await crowdFund.methods.requests(0).call();

    assert.equal("Buy metal", req.description);
  });

  it("processes requests", async () => {
    await crowdFund.methods.contribute().send({
      from: accounts[0],
      value: web3.utils.toWei("10", "ether"),
    });

    await crowdFund.methods
      .createRequest("Test", web3.utils.toWei("10", "ether"), accounts[1])
      .send({
        from: accounts[0],
        gas: "1000000",
      });

    await crowdFund.methods.approveRequest(0).send({
      from: accounts[0],
      gas: "1000000",
    });

    await crowdFund.methods.finaliseRequest(0).send({
      from: accounts[0],
      gas: "1000000",
    });

    let balance = await web3.eth.getBalance(accounts[1]);
    balance = web3.utils.fromWei(balance, "ether");
    balance = parseFloat(balance);

    assert(balance > 102);
  });
});
