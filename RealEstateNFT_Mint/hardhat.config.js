
require("@nomicfoundation/hardhat-toolbox");
// require('@nomiclabs/hardhat-waffle');
// require('@nomiclabs/hardhat-ethers');

const { projectId, mnemonic } = require('./secrets.js');

module.exports = {
  solidity: "0.8.20",
  networks: {
    hardhat: {},
    ropsten: {
      url: `https://ropsten.infura.io/v3/${projectId}`,
      accounts: { mnemonic: mnemonic },
    },
  },
  etherscan: {
    apiKey: 'HEZNFQG3FI4DETXW5BJMATUG2AWBF2GZMG',
  },
};

