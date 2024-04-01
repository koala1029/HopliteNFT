/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
const SEPOLIA_PRIVATE_KEY = "73846b798e68127eb16a0b7caac790e3c68852eeb7b06d628ade43d6725a5698";
module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 10,
        details: {
          constantOptimizer: true,
        },
      },
      // viaIR: true,
    },
  },
  networks: {
    // sepolia: {
    //   url: `https://ethereum-sepolia.publicnode.com`,
    //   accounts: [SEPOLIA_PRIVATE_KEY]
    // }
    sepolia: {
      url: `https://ethereum-sepolia.publicnode.com`,
      accounts: [SEPOLIA_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      sepolia: '5MZF8XBDIDP8XTUMI7D9VZZ3AFZYCQYBCY'
    }
  }
};
