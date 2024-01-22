const express = require('express');
const mongoose = require('mongoose');
const { ethers } = require('ethers');
const bodyParser = require('body-parser');
const [ABI, ContractAddress] = require('./SmartStoreBillNFT.js')
// console.log(ABI, ContractAddress);


const app = express();
const server = app.listen(8000, () => {
    const { port } = server.address();
    console.log(`Server is running on port ${port}`);
});

app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/smartstore', { useNewUrlParser: true, useUnifiedTopology: true });

const billSchema = new mongoose.Schema({
    BillId: Number,
    ProductId: Number, 
    name: String,
    owner: String,
    price: Number
  });

const BillModel = mongoose.model('Bill', billSchema);  

// Connect to Ethereum
const provider = new ethers.providers.JsonRpcProvider('https://sepolia.infura.io/v3/df3074c5878c41ffadad5040d7b08329'); 
const wallet = new ethers.Wallet('d5661198df1326071910533292c4560f61fb138ab777c11238064149dc96df6d', provider);
const BillNFTContract = new ethers.Contract(ContractAddress, ABI, wallet);

app.get('/', (req,res) =>{
    res.render('index');
})

app.post('/BillTheProduct', async (req, res) => {
    const BillID = req.body.BillId;
    const OwnerAddress = req.body.OwnerAddress;
    BillDetails = await BillNFTContract.getDetails(BillID,OwnerAddress);
    // console.log(BillDetails.id);

    const newBill = new BillModel({
        BillId: BillID,
        ProductId: BillDetails.id,
        name: BillDetails.name,
        Owner: OwnerAddress,
        price: BillDetails.price
      });
    
    await newBill.save();
    
    console.log("Details have been added to DB");

    res.redirect('/');
});

