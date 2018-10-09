const HDWallerProvider = require("truffle-hdwallet-provider");
const Web3 = require("web3");
const { route, routeCreator } = require("./compile");
// console.log(route.bytecode);
// console.log(route.interface);
const fs = require("fs");
const date = new Date();
const RInterface = route.interface;
const RByte = route.bytecode;
const RCInterface = routeCreator.interface;
const RCByte = routeCreator.bytecode;

const provider = new HDWallerProvider(
  "december bomb print venue quantum balcony model slogan trouble blade arena believe",
  "https://rinkeby.infura.io/v3/232565dedf3b408ea93b991ed92c70c4"
);

const web3 = new Web3(provider);

// const deployRouteCreatorContract = async () => {
//   const accounts = await web3.eth.getAccounts();
//   console.log(`Attempting to deploy from account ${accounts[0]}`);
//   let result;
//   try {
//     result = await new web3.eth.Contract(JSON.parse(RCInterface))
//       .deploy({
//         data: RCByte
//       })
//       .send({ from: accounts[0], gas: "6000000" });
//   } catch (e) {
//     console.log(`Something went wrong:: ${e}`);
//   }
//   console.log(
//     `Route Creator Contract has been successfully deployed to ${
//       result.options.address
//     }`
//   );
//   fs.appendFile(
//     "./logs.txt",
//     `Route Creator Contract deployed to ${
//       result.options.address
//     } on ${date.toLocaleTimeString()}\r\n`,
//     err => {
//       if (err) console.log(`something went wrong while writing into the file`);
//       else console.log(`Success!`);
//     }
//   );
// };
// deployRouteCreatorContract();

const deployRouteContract = async () => {
  const accounts = await web3.eth.getAccounts();
  let result;
  console.log(`Attempting to deploy from account ${accounts[0]}`);
  try {
    result = await new web3.eth.Contract(JSON.parse(RInterface))
      .deploy({
        data: RByte,
        arguments: [
          accounts[0],
          "r1",
          3,
          [
            web3.utils.fromAscii("stop1"),
            web3.utils.fromAscii("stop2"),
            web3.utils.fromAscii("stop3")
          ]
        ]
      })
      .send({ from: accounts[0], gas: "2000000" });
  } catch (e) {
    console.log(`Something went wrong:: ${e}`);
  }
  console.log(
    `Route Contract has been successfully deployed to ${result.options.address}`
  );
  fs.appendFile(
    "./logs.txt",
    `Route Contract deployed to ${
      result.options.address
    } on ${date.toLocaleTimeString()}\r\n`,
    err => {
      if (err) console.log(`something went wrong while writing into the file`);
      else console.log(`Success!`);
    }
  );
};
deployRouteContract();
