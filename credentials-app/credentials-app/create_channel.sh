#!/bin/bash
source ../terminal_control.sh
export PATH=/home/rakeshdms/fabric-components/binV2.5:$PATH
export FABRIC_CFG_PATH=${PWD}/../config/
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/msp/tlscacerts/tlsca.credentials.com-cert.pem

export CHANNEL_NAME=credentials-channel

setEnvForPeer0Admin() {
    export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/ca.crt
    export CORE_PEER_LOCALMSPID=AdminMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/admin.credentials.com/users/Admin@admin.credentials.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setEnvForPeer1Admin() {
    export PEER1_ORG1_CA=${PWD}/organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/ca.crt
    export CORE_PEER_LOCALMSPID=AdminMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/admin.credentials.com/users/Admin@admin.credentials.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
}

setEnvForPeer0User() {
    export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/ca.crt
    export CORE_PEER_LOCALMSPID=UserMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/user.credentials.com/users/Admin@user.credentials.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

setEnvForPeer1User() {
    export PEER1_ORG2_CA=${PWD}/organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/ca.crt
    export CORE_PEER_LOCALMSPID=UserMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/user.credentials.com/users/Admin@user.credentials.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
}

# setEnvForPeer0CommercialBank2() {
#     export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/ca.crt
#     export CORE_PEER_LOCALMSPID=CommercialBank2MSP
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/commercialbank2.credentials.com/users/Admin@commercialbank2.credentials.com/msp
#     export CORE_PEER_ADDRESS=localhost:11051
# }

# setEnvForPeer1CommercialBank2() {
#     export PEER1_ORG3_CA=${PWD}/organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/ca.crt
#     export CORE_PEER_LOCALMSPID=CommercialBank2MSP
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG3_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/commercialbank2.credentials.com/users/Admin@commercialbank2.credentials.com/msp
#     export CORE_PEER_ADDRESS=localhost:12051
# }

createChannel() {
    setEnvForPeer0Admin

    print Green "========== Creating Channel =========="
    echo ""
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.credentials.com \
    -f ./channel-artifacts/$CHANNEL_NAME.tx --outputBlock \
    ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA 
    echo ""
}

joinChannel() {
    
    setEnvForPeer0Admin
    print Green "========== Peer0Admin Joining Channel '$CHANNEL_NAME' =========="
    peer channel join --tls  -b ./channel-artifacts/$CHANNEL_NAME.block 
    echo ""

    setEnvForPeer1Admin
    print Green "========== Peer1Admin Joining Channel '$CHANNEL_NAME' =========="
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    echo ""

    setEnvForPeer0User
    print Green "========== Peer0User Joining Channel '$CHANNEL_NAME' =========="
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    echo ""

    setEnvForPeer1User
    print Green "========== Peer1User Joining Channel '$CHANNEL_NAME' =========="
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    echo ""

    # setEnvForPeer0CommercialBank2
    # print Green "========== Peer0CommercialBank2 Joining Channel '$CHANNEL_NAME' =========="
    # peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    # echo ""

    # setEnvForPeer1CommercialBank2
    # print Green "========== Peer1CommercialBank2 Joining Channel '$CHANNEL_NAME' =========="
    # peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    # echo ""
}

updateAnchorPeers() {
    setEnvForPeer0Admin
    print Green "========== Updating Anchor Peer of Peer0Admin =========="
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    echo ""

    setEnvForPeer0User
    print Green "========== Updating Anchor Peer of Peer0User =========="
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    echo ""

    # setEnvForPeer0CommercialBank2
    # print Green "========== Updating Anchor Peer of Peer0CommercialBank2 =========="
    # peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    # echo ""
}

createChannel
joinChannel
updateAnchorPeers