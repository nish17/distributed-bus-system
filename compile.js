const path = require("path");
const fs = require("fs");
const solc = require("solc");

const Route = path.resolve(__dirname, "contracts", "Route.sol");
const source = fs.readFileSync(Route, "utf-8");
// console.log(solc.compile(source, 1));
module.exports = solc.compile(source, 1).contracts[":Route"];

// const project = artifacts.require("./contracts/busSystem.sol");
// console.log(project);
