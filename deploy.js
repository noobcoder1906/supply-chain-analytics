const Web3 = require('web3');
const fs = require('fs');
const solc = require('solc'); // Add this line

class MyContract {
    constructor(web3) {
        this.web3 = web3;
    }

    async getOrganState(organId) {
        // Get the deployed contract address
        const contractAddress = '0xf8e81D47203A594245E36C48e151709F0C19fBe8'; // Replace with your deployed contract address
    
        // Create a new instance of the contract using its ABI and deployed address
        const contractInstance = new this.web3.eth.Contract(abi, contractAddress);
    
        try {
            // Call the getOrganState function of the contract
            const state = await contractInstance.methods.getOrganState(organId).call();
    
            // Return the state of the organ
            return state;
        } catch (error) {
            console.error('Error getting organ state:', error);
            throw error;
        }
    }
}

const web3 = new Web3(); // Connect to Ganache via WebSocket
const contractFile = fs.readFileSync('./OrganSupplyChain.sol', 'utf8');
const input = {
    language: 'Solidity',
    sources: {
        'OrganSupplyChain.sol': {
            content: contractFile,
        },
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*'],
            },
        },
    },
};

const output = JSON.parse(solc.compile(JSON.stringify(input)));
const bytecode = output.contracts['OrganSupplyChain.sol']['OrganSupplyChain'].evm.bytecode.object;
const abi = output.contracts['OrganSupplyChain.sol']['OrganSupplyChain'].abi;

const contract = new web3.eth.Contract(abi);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    const deployedContract = await contract.deploy({
        data: bytecode,
    }).send({
        from: accounts[0],
        gas: '6721975', // Gas limit
    });
    console.log('Contract deployed to:', deployedContract.options.address);
};

deploy();

module.exports = MyContract;
