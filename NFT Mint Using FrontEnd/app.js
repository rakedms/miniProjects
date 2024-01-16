const contractAddress = "0xc5c51c95663aebb3bc706c46310d796cf8d4aaac";
const ABI = require('./ABI');
const ProviderUrl = "https://sepolia.infura.io/v3/df3074c5878c41ffadad5040d7b08329";
const PrivateKey = "d5661198df1326071910533292c4560f61fb138ab777c11238064149dc96df6d";
const ethers = require('ethers')
const express = require('express');
const app = express();
const path = require('path');
const bodyParser = require('body-parser'); 

const Provider = new ethers.providers.JsonRpcProvider(ProviderUrl);
const wallet = new ethers.Wallet(PrivateKey, Provider);
let contract; // Declare the contract variable outside the route handlers

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => {
    
    let MintedStatus = req.query.MintStatus;
    // let mintedTokenAddress = req.query.mintedTokenAddress;
    let ContractConectStatus = req.query.ContractConectStatus;
    let MintTx = req.query.MintTx;
    console.log(ContractConectStatus)
    res.render('index', { MintedStatus, ContractConectStatus, MintTx});
});

app.get('/connectContract', async (req, res) => {
    try {
        contract = await new ethers.Contract(contractAddress, ABI, wallet)
        console.log("Successfully connected to the contract");
        res.redirect(`/?ContractConectStatus=${"Success"}`);
    } 
    catch (Error){
        console.log('Error connecting to the contract:', error);
        res.status(500).send('Failed to connect to the contract');
    }
});

app.post('/mintNFT', async (req, res) => {

    try {
        if (!contract) {
            throw new Error('Contract is not connected');
        }
        let Status ='';

        let toAddress = req.body.ToAddress;
        let tokenId = req.body.TokenID;
        let TokenUri = req.body.uri;
        let txHash ;
        console.log(toAddress, tokenId, TokenUri )

        const MintTransaction = await contract.Mint(toAddress, tokenId, TokenUri, { gasLimit: 2000000 });
        const txReceipt = await MintTransaction.wait();
        txHash = txReceipt.transactionHash;

        Status = "Minted";
        res.redirect(`/?MintTx=${txHash}`);
    } catch (error) {
        console.error('Error minting NFT:', error);
        txHash = error.receipt.transactionHash;
        Status = "Failed to Minted"
        res.redirect(`/?MintTx=${txHash}`);
    }
});

const server = app.listen(8000);
const portnumber = server.address().port;
console.log(`Server is running on port ${portnumber}`);
