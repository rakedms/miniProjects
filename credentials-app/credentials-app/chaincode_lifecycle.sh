#!/bin/bash
source ../terminal_control.sh
export PATH=/home/rakeshdms/fabric-components/binV2.5:$PATH
export PATH=/usr/local/go/bin:$PATH 
export FABRIC_CFG_PATH=${PWD}/../config
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/msp/tlscacerts/tlsca.credentials.com-cert.pem
export CORE_PEER_TLS_ROOTCERT_FILE_ORG1=${PWD}/organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE_ORG2=${PWD}/organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/ca.crt
# export CORE_PEER_TLS_ROOTCERT_FILE_ORG3=${PWD}/organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/ca.crt

CHANNEL_NAME="credentials-channel"
CHAINCODE_NAME="credentials-app"
CHAINCODE_VERSION="1.0"
CHAINCODE_PATH="../chaincode/credentials-app/"
CHAINCODE_LABEL="credentials-app-1"

setEnvForAdmin() {
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=AdminMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/admin.credentials.com/users/Admin@admin.credentials.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setEnvForUser() {
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=UserMSP
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/user.credentials.com/users/Admin@user.credentials.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

# setEnvForCommercialBank2() {
#     export CORE_PEER_TLS_ENABLED=true
#     export CORE_PEER_LOCALMSPID=CommercialBank2MSP
#     export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/ca.crt
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/commercialbank2.credentials.com/users/Admin@commercialbank2.credentials.com/msp
#     export CORE_PEER_ADDRESS=localhost:11051
# }

packageChaincode() {
    rm -rf ${CHAINCODE_NAME}.tar.gz
    setEnvForAdmin
    print Green "========== Packaging Chaincode on Peer0 Admin =========="
    peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CHAINCODE_PATH} --lang golang --label ${CHAINCODE_LABEL}
    echo ""
    print Green "========== Packaging Chaincode on Peer0 Admin Successful =========="
    ls
    echo ""
}

installChaincode() {
    setEnvForAdmin
    print Green "========== Installing Chaincode on Peer0 Admin =========="
    peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE}
    print Green "========== Installed Chaincode on Peer0 Admin =========="
    echo ""

    setEnvForUser
    print Green "========== Installing Chaincode on Peer0 admin =========="
    peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz --peerAddresses localhost:9051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE}
    print Green "========== Installed Chaincode on peer0 admin =========="
    echo ""

    # setEnvForCommercialBank2
    # print Green "========== Installing Chaincode on Peer0 commercialbank2 =========="
    # peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz --peerAddresses localhost:11051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE}
    # print Green "========== Installed Chaincode on Peer0 commercialbank2 =========="
    # echo ""
}

queryInstalledChaincode() {
    setEnvForAdmin
    print Green "========== Querying Installed Chaincode on Peer0 Admin=========="
    peer lifecycle chaincode queryinstalled --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE} >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CHAINCODE_LABEL}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    print Yellow "PackageID is ${PACKAGE_ID}"
    print Green "========== Query Installed Chaincode Successful on Peer0 Admin=========="
    echo ""
}

approveChaincodeByAdmin() {
    setEnvForAdmin
    print Green "========== Approve Installed Chaincode by Peer0 Admin =========="
    peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com --tls --cafile ${ORDERER_CA} --channelID credentials-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --package-id ${PACKAGE_ID} --sequence 1 --init-required
    print Green "========== Approve Installed Chaincode Successful by Peer0 Admin =========="
    echo ""
}

checkCommitReadynessForAdmin() {
    setEnvForAdmin
    print Green "========== Check Commit Readiness of Installed Chaincode on Peer0 Admin =========="
    peer lifecycle chaincode checkcommitreadiness -o localhost:7050 --channelID ${CHANNEL_NAME} --tls --cafile ${ORDERER_CA} --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --sequence 1 --output json --init-required
    print Green "========== Check Commit Readiness of Installed Chaincode Successful on Peer0 Admin =========="
    echo ""
}

approveChaincodeByUser() {
    setEnvForUser
    print Green "========== Approve Installed Chaincode by Peer0 admin =========="
    peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com --tls --cafile ${ORDERER_CA} --channelID credentials-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --package-id ${PACKAGE_ID} --sequence 1 --init-required
    print Green "========== Approve Installed Chaincode Successful by Peer0 admin =========="
    echo ""
}

checkCommitReadynessForUser() {
    setEnvForUser
    print Green "========== Check Commit Readiness of Installed Chaincode on Peer0 admin =========="
    peer lifecycle chaincode checkcommitreadiness -o localhost:7050 --channelID ${CHANNEL_NAME} --tls --cafile ${ORDERER_CA} --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --sequence 1 --output json --init-required
    print Green "========== Check Commit Readiness of Installed Chaincode Successful on Peer0 admin =========="
    echo ""
}

# # approveChaincodeByCommercialBank2() {
# #     setEnvForCommercialBank2
# #     print Green "========== Approve Installed Chaincode by Peer0 commercialbank2 =========="
# #     peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com --tls --cafile ${ORDERER_CA} --channelID credentials-channel --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --package-id ${PACKAGE_ID} --sequence 1 --init-required
# #     print Green "========== Approve Installed Chaincode Successful by Peer0 commercialbank2 =========="
# #     echo ""
# }

# checkCommitReadynessForCommercialBank2() {
#     setEnvForCommercialBank2
#     print Green "========== Check Commit Readiness of Installed Chaincode on Peer0 commercialbank2 =========="
#     peer lifecycle chaincode checkcommitreadiness -o localhost:7050 --channelID ${CHANNEL_NAME} --tls --cafile ${ORDERER_CA} --name ${CHAINCODE_NAME} --version ${CHAINCODE_VERSION} --sequence 1 --output json --init-required
#     print Green "========== Check Commit Readiness of Installed Chaincode Successful on Peer0 commercialbank2 =========="
#     echo ""
# }

commitChaincode() {
    setEnvForAdmin
    print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} =========="
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com --tls ${CORE_PEER_TLS_ENABLED} --cafile ${ORDERER_CA} --channelID ${CHANNEL_NAME} --name ${CHAINCODE_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_ORG1} --peerAddresses localhost:9051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_ORG2} --peerAddresses localhost:11051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_ORG3} --version ${CHAINCODE_VERSION} --sequence 1 --init-required
    print Green "========== Commit Installed Chaincode on ${CHANNEL_NAME} Successful =========="
    echo ""
}

queryCommittedChaincode() {
    setEnvForAdmin
    print Green "========== Query Committed Chaincode on ${CHANNEL_NAME} =========="
    peer lifecycle chaincode querycommitted --channelID ${CHANNEL_NAME} --name ${CHAINCODE_NAME}
    print Green "========== Query Committed Chaincode on ${CHANNEL_NAME} Successful =========="
    echo ""
}

getInstalledChaincode() {
    setEnvForAdmin
    print Green "========== Get Installed Chaincode from Peer0 Admin =========="
    peer lifecycle chaincode getinstalledpackage --package-id ${PACKAGE_ID} --output-directory . --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE}
    print Green "========== Get Installed Chaincode from Peer0 Admin Successful =========="
    echo ""
}

queryApprovedChaincode() {
    setEnvForAdmin
    print Green "========== Query Approved of Installed Chaincode on Peer0 Admin =========="
    peer lifecycle chaincode queryapproved -C s${CHANNEL_NAME} -n ${CHAINCODE_NAME} --sequence 1 
    print Green "========== Query Approved of Installed Chaincode on Peer0 Admin Successful =========="
    echo ""
}

initChaincode() {
    setEnvForAdmin
    print Green "========== Init Chaincode on Peer0 Admin ========== "
    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.credentials.com --tls ${CORE_PEER_TLS_ENABLED} --cafile ${ORDERER_CA} -C ${CHANNEL_NAME} -n ${CHAINCODE_NAME} --peerAddresses localhost:7051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_ORG1} --peerAddresses localhost:9051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_ORG2} --peerAddresses localhost:11051 --tlsRootCertFiles ${CORE_PEER_TLS_ROOTCERT_FILE_ORG3} --isInit -c '{"Args":[]}'
    print Green "========== Init Chaincode on Peer0 Admin Successful ========== "
    echo ""
}

if [[ $1 == "packageChaincode" ]]
then
packageChaincode
elif [[ $1 == "installChaincode" ]]
then
installChaincode
elif [[ $1 == "queryInstalledChaincode" ]]
then
queryInstalledChaincode
elif [[ $1 == "approveChaincodeByAdmin" ]]
then
approveChaincodeByAdmin
elif [[ $1 == "checkCommitReadynessForAdmin" ]]
then
checkCommitReadynessForAdmin
elif [[ $1 == "approveChaincodeByUser" ]]
then
approveChaincodeByUser
elif [[ $1 == "checkCommitReadynessForUser" ]]
then
checkCommitReadynessForUser
elif [[ $1 == "approveChaincodeByCommercialBank2" ]]
then
# approveChaincodeByCommercialBank2
# elif [[ $1 == "checkCommitReadynessForCommercialBank2" ]]
# then
# checkCommitReadynessForCommercialBank2
# elif [[ $1 == "commitChaincode" ]]
# then
commitChaincode
elif [[ $1 == "queryCommittedChaincode" ]]
then
queryCommittedChaincode
elif [[ $1 == "getInstalledChaincode" ]]
then
getInstalledChaincode
elif [[ $1 == "queryApprovedChaincode" ]]
then
queryApprovedChaincode
elif [[ $1 == "initChaincode" ]]
then
initChaincode
elif [[ $1 == "help" ]]
then
echo "Usage:" 
echo "       source chaincode_lifecycle.sh [option]"
echo "Options Available:"
echo "Follow this options in sequence"
echo "[ packageChaincode | installChaincode | queryInstalledChaincode | approveChaincodeByAdmin ]"
echo "[ checkCommitReadynessForAdmin | approveChaincodeByUser | checkCommitReadynessForUser ]"
# echo "[ approveChaincodeByCommercialBank2 | checkCommitReadynessForCommercialBank2 | approveChaincodeByGoodsCustomOrg4 ]"
echo "[ checkCommitReadynessForGoodsCustomOrg4 | commitChaincode | queryCommittedChaincode | initChaincode ]"
echo "Other Options:"
echo "[ default(run all options in sequence at once) | getInstalledChaincode | queryApprovedChaincode | help ]"
elif [[ $1 == "default" ]]
then
packageChaincode
installChaincode
queryInstalledChaincode
approveChaincodeByAdmin
checkCommitReadynessForAdmin
approveChaincodeByUser
checkCommitReadynessForUser
# approveChaincodeByCommercialBank2
# checkCommitReadynessForCommercialBank2
commitChaincode
queryCommittedChaincode
initChaincode
else
print Red "$1: Invalid option. (try: source chaincode_lifecycle.sh help)"
fi

