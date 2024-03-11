#!/bin/bash 
source ../terminal_control.sh
export PATH=/home/rakeshdms/fabric-components/binV2.5:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx/
print Blue "$FABRIC_CFG_PATH"

# # Generate crypto material using cryptogen tool
# print Green "========== Generating Crypto Material =========="
# echo ""

# ../../fabric-samples/bin/cryptogen generate --config=./crypto-config.yaml --output="organizations"

# print Green "========== Crypto Material Generated =========="
# echo ""

SYS_CHANNEL=credentials-sys-channel
print Purple "System Channel Name: "$SYS_CHANNEL
echo ""

CHANNEL_NAME=credentials-channel
print Purple "Application Channel Name: "$CHANNEL_NAME
echo ""

# Generate System Genesis Block using configtxgen tool
print Green "========== Generating System Genesis Block =========="
echo ""

configtxgen -configPath ./configtx/ -profile credentialsOrdererGenesis -channelID $SYS_CHANNEL -outputBlock ./channel-artifacts/genesis.block

print Green "========== System Genesis Block Generated =========="
echo ""

print Green "========== Generating Channel Configuration Block =========="
echo ""

configtxgen -profile credentialsChannel -configPath ./configtx/ -outputCreateChannelTx ./channel-artifacts/credentials-channel.tx -channelID $CHANNEL_NAME 

print Green "========== Channel Configuration Block Generated =========="
echo ""

print Green "========== Generating Anchor Peer Update For AdminMSP =========="
echo ""

configtxgen -profile credentialsChannel -configPath ./configtx/ -outputAnchorPeersUpdate ./channel-artifacts/AdminMSPAnchor.tx -channelID $CHANNEL_NAME -asOrg AdminMSP

print Green "========== Anchor Peer Update For AdminMSP Sucessful =========="
echo ""

print Green "========== Generating Anchor Peer Update For UserMSP =========="
echo ""

configtxgen -profile credentialsChannel -configPath ./configtx/ -outputAnchorPeersUpdate ./channel-artifacts/UserMSPAnchor.tx -channelID $CHANNEL_NAME -asOrg UserMSP

print Green "========== Anchor Peer Update For UserMSP Sucessful =========="
echo ""

