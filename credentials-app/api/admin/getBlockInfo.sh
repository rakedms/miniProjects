export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="AdminMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../../credentials-app/organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../credentials-app/organizations/peerOrganizations/admin.credentials.com/users/Admin@admin.credentials.com/msp/
export CORE_PEER_ADDRESS=localhost:7051

export FABRIC_CFG_PATH=${PWD}/../../config/
#peer channel fetch newest supplychain-channel.block -c supplychain-channel --orderer orderer.supplychain.com:7050
peer channel getinfo -c credentials-channel > block.json 
cat block.json | cut -c 18- > blockchainInfo.json