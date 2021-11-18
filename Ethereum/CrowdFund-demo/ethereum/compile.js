const path = require("path");
const solc = require("solc");
const fs = require("fs-extra");

// delete existing build folder if exists
const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath);

// get contracts
const crowdFundPath = path.resolve(__dirname, "contracts", "CrowdFund.sol");
const source = fs.readFileSync(crowdFundPath, "utf8");
const output = solc.compile(source, 1).contracts;

fs.ensureDirSync(buildPath);

// export contracts to separate files
for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(":", "") + ".json"),
    output[contract]
  );
}
