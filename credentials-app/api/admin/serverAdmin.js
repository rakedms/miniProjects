'use strict'

// const { registerEnroll } = require('./registerEnrollClientUser')
let express = require('express')
let bodyParser = require('body-parser')

let app = express()
app.use(bodyParser.json())

const { Gateway, Wallets } = require('fabric-network')
const path = require('path')
const fs = require('fs')
const { error } = require('console')

async function invokeChaincode(func, args) {
    try {
        const gateway = new Gateway();
        await gateway.connect(ccp, {
            wallet_path: path.join(__dirname, '..', 'wallet'),
            identity: 'user1',
            discovery: { enabled: true, asLocalhost: true }
        });
        //need to update channel name
        const network = await gateway.getNetwork('credentials-channel');
        const contract = network.getContract('credentialsAppContract');

        const result = await contract.submitTransaction(func, ...args);
        return result.toString();
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        return error.message;
    }
}

app.get('/', async function (req, res) {
    try {
        console.log("Test Pass!..")
        res.status(200).json({ response: "Test Pass!..."})
    } catch (error) {
        console.log("Test Fail!..")
        process.exit(1)
    }
})

app.post('/signup', async (req, res) => {
    const { userID, username, password, email, role } = req.body;
    const result = await invokeChaincode('SignUp', [userID, username, password, email, role]);
    res.send(result);
});


app.post('/login', async (req, res) => {
    const { userID, password } = req.body;
    const result = await invokeChaincode('Login', [userID, password]);
    res.send(result);
});


app.delete('/deleteUser', async (req, res) => {
    const { userID } = req.body;
    const result = await invokeChaincode('DeleteUser', [userID]);
    res.send(result);
});


app.put('/updateUser', async (req, res) => {
    const { userID, newUsername, newPassword, newEmail } = req.body;
    const result = await invokeChaincode('UpdateUserDetails', [userID, newUsername, newPassword, newEmail]);
    res.send(result);
});



app.listen(8081, 'localhost');
console.log('credentials-app is running on http://localhost:8081');