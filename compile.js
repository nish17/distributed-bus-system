const path = require("path");
const fs = require("fs");
const solc = require("solc");

const busSystemPath = path.resolve(__dirname, "contracts", "busSystem.sol");
const source = fs.readFileSync(busSystemPath, "utf-8");

module.exports = solc.compile(source, 1).contracts[":System"];

// const project = artifacts.require("./contracts/busSystem.sol");
// console.log(project);
