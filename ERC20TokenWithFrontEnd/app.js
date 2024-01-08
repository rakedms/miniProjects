const express = require('express');
const ABI = require('./ABI.js');
const ethers = require('ethers');
const app = express();
const contractAddress = '0x3a0DcbF50c26F4D882b1A1022E30ab416c9d88Dc';
const privateKey = 'd5661198df1326071910533292c4560f61fb138ab777c11238064149dc96df6d'

const server = app.listen(8000);
console.log(`server started in ${server.address().port}`);

app.set('view engine', 'ejs');
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

// Connect to contract
const provider = new ethers.providers.JsonRpcProvider('https://sepolia.infura.io/v3/df3074c5878c41ffadad5040d7b08329');
console.log("Provider Connected");

const contract = new ethers.Contract(contractAddress, ABI, provider);
console.log("Contract Connected");

const wallet = new ethers.Wallet(privateKey, provider);
console.log("Wallet Connected");

app.get('/', (req, res) => {
    TotalSupply =req.query.Supply || 'NA';
    balanceOf = req.query.balance;
    transfered = req.query.transferedStatus;
    transferFromStatus = req.query.transferFromStatus;
    transferError = req.query.Err;
    AdminAdded = req.query.AddAdminStatus;
    console.log(TotalSupply)
    res.render('index', {balanceOf, transfered, transferFromStatus, transferError, AdminAdded, TotalSupply})
    // console.log(balanceOf)
    // console.log(transfered)
});

app.get('/totalSupply', async (req,res)=>{
    let InitialSupply = await contract.totalSupply();
    InitialSupply = InitialSupply.toString()
    res.redirect(`/?Supply=${InitialSupply}`)
})

app.post('/balance', async (req, res) => {
    let BalanceOfAddress = req.body.Address;
    let Balance = await contract.balanceOf(BalanceOfAddress);
    res.redirect(`/?balance=${Balance}`);
});

app.post('/transfer', async(req,res) =>{
    let FromAddress=req.body.fromAddress;
    let ToAddress = req.body.toAddress;
    let Qty = req.body.Qty;
    console.log(`${FromAddress}, ${Qty}, ${ToAddress}`)
    if(!ethers.utils.isAddress(ToAddress)){
        console.log("Incorrect Address");
        res.redirect('/')
    }

    await contract.connect(wallet).transfer(FromAddress,Qty,ToAddress).then(()=>{
        let status= "Success"
        res.redirect(`/?transferedStatus=${status}`)
    })

app.post('/AddAdmin', async (req,res)=>{
    let OwnerAddress = req.body.OwnerAddress ;
    let AdminAddress = req.body.AdminAddress;
    let Qty = req.body.Qty;

    await contract.approve(OwnerAddress,AdminAddress,Qty).then(()=>{
        let AddAdminStatus = "Success";
        res.redirect(`/?AddAdminStatus=${AddAdminStatus}`)
    })

})    

app.post('/transferFrom',async(req,res) =>{
    let FromAddress = req.body.FromAddress;
    let toAddress = req.body.toAddress;
    let AdminAddress = req.body.AdminAddress;
    let quantity = req.body.quantity;
    await contract.connect(wallet).transferFrom(FromAddress, AdminAddress, toAddress, quantity).then(()=>{
        let SentStatus = "Success"
        res.redirect(`/?transferFromStatus=${SentStatus}`)})
        .catch((e)=>{
            res.redirect(`/?Err=${e}`)
        })
    })
})





