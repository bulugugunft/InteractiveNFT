'use strict';

var HDWalletProvider = require("@truffle/hdwallet-provider")

const isCoverage = process.env.COVERAGE === 'true'

module.exports = {
  networks: {

    local: {
      host: 'localhost',
      port: 8545,
      gas: 6999999,
      gasPrice: 1 * 1000000000,
      network_id: '*'
    },

    rinkeby: {
      provider: function() {
        const mnemonic = ''
        return new HDWalletProvider(mnemonic, '')
      },
      network_id: 4,
      skipDryRun: true,
      networkCheckTimeout: 10000,
      gas: 4612388  // Gas limit used for deploys
    },

    mainnet: {
      provider: () => new HDWalletProvider(
        process.env.HDWALLET_MNEMONIC,
        process.env.INFURA_PROVIDER_URL_MAINNET,
        0,
        3
      ),
      skipDryRun: true,
      network_id: 1,
      gas: 7000000,
      gasPrice: 3.01 * 1000000000
    },
  },

  plugins: ["solidity-coverage"],

  compilers: {
    solc: {
      version: "0.8.0",
      settings: {
        evmVersion: 'constantinpole'
      }
    }
  },

  // optimization breaks code coverage
  solc: {
    optimizer: {
      enabled: !isCoverage,
      runs: 200
    }
  },

  mocha: isCoverage ? {
    reporter: 'mocha-junit-reporter',
  } : {
    reporter: 'eth-gas-reporter',
    reporterOptions : {
      currency: 'USD',
      gasPrice: 10
    }
  }
};