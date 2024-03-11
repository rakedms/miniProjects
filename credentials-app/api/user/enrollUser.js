'use strict'
const FabricCAServices = require('fabric-ca-client')
const { Wallets } = require('fabric-network')
const fs = require('fs')
const path = require('path')

async function main() {
    try {
        // load the network configuration
        const ccpPath = path.resolve(__dirname, 'connection-user.json')
        const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf-8'))

        // Create a new CA Client for interacting with the CA.
        const caInfo = ccp.certificateAuthorities['ca.user.credentials.com']
        const caTLSCACerts = caInfo.tlsCACerts.pem
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName)

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'walletUser')
        const wallet = await Wallets.newFileSystemWallet(walletPath)
        console.log(`Wallet path: ${walletPath}`)

        // Check to see if we've already enrolled the user user.
        const identity = await wallet.get('user')
        if (identity) {
            console.log('An identity for the user "user" already exists in the wallet')
            return
        }

        // Enroll the user user, and import the new identity init the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw' })
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: 'User',
            type: 'X.509',
        }
        await wallet.put('user', x509Identity)
        console.log('Successfully enrolled user user "user" and imported it into the wallet')
    } catch (error) {
        console.error(`Failed to enroll user user "user": ${error}`)
        process.exit(1)
    }
}

main()