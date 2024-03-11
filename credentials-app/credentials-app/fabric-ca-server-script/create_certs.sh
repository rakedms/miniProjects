export PATH=/home/rakeshdms/fabric-components/binV2.5:$PATH
createCertForAdmin() {
    echo
    echo "Enroll CA admin of Admin"
    echo
    mkdir -p ../organizations/peerOrganizations/admin.credentials.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/admin.credentials.com/

    fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.admin.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin-credentials-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin-credentials-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin-credentials-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-admin-credentials-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/config.yaml

    echo
    echo "Register peer0.admin"
    echo

    fabric-ca-client register --caname ca.admin.credentials.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    echo
    echo "Register peer1.admin"
    echo

    fabric-ca-client register --caname ca.admin.credentials.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    echo
    echo "Register user1.admin"
    echo

    fabric-ca-client register --caname ca.admin.credentials.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    echo
    echo "Register admin.admin"
    echo

    fabric-ca-client register --caname ca.admin.credentials.com --id.name org1admin --id.secret adminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    mkdir -p ../organizations/peerOrganizations/admin.credentials.com/peers
    
    # -----------------------------------------------------------------------------------
    # Peer0
    mkdir -p ../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com

    echo
    echo "Generate Peer0 MSP"
    echo

    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.admin.credentials.com -M ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/msp --csr.hosts peer0.admin.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/msp/config.yaml

    echo
    echo "Generate Peer0 TLS-CERTs"
    echo

    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.admin.credentials.com -M ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls --enrollment.profile tls --csr.hosts peer0.admin.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/ca.crt
    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/server.crt
    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/server.key

    mkdir ${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/tlscacerts
    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/tlscacerts/ca.crt

    mkdir ${PWD}/../organizations/peerOrganizations/admin.credentials.com/tlsca
    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/tlsca/tlsca.admin.credentials.com-cert.pem

    mkdir ${PWD}/../organizations/peerOrganizations/admin.credentials.com/ca
    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer0.admin.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/ca/ca.admin.credentials.com-cert.pem

    # -----------------------------------------------------------------------------------
    # Peer1
    mkdir -p ../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com

    echo
    echo "Generate Peer1 MSP"
    echo

    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.admin.credentials.com -M ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/msp --csr.hosts peer1.admin.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/msp/config.yaml

    echo
    echo "Generate Peer1 TLS-CERTs"
    echo

    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.admin.credentials.com -M ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls --enrollment.profile tls --csr.hosts peer1.admin.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/ca.crt
    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/server.crt
    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/server.key

    # mkdir ${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/tlscacerts
    # cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/tlscacerts/ca.crt

    # mkdir ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tlsca
    # cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/tlsca/tlsca.admin.credentials.com-cert.pem

    # mkdir ${PWD}/../organizations/peerOrganizations/admin.credentials.com/ca
    # cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/peers/peer1.admin.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/admin.credentials.com/ca/ca.admin.credentials.com-cert.pem
    
    # ------------------------------------------------------------------------------------------
    mkdir -p ../organizations/peerOrganizations/admin.credentials.com/users
    mkdir -p ../organizations/peerOrganizations/admin.credentials.com/users/User1@admin.credentials.com

    echo
    echo "Generate User1 MSP"
    echo
    fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.admin.credentials.com -M ${PWD}/../organizations/peerOrganizations/admin.credentials.com/users/User1@admin.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    mkdir -p ../organizations/peerOrganizations/admin.credentials.com/users/Admin@admin.credentials.com

    echo
    echo "Generate Admin Admin MSP"
    echo

    fabric-ca-client enroll -u https://org1admin:adminpw@localhost:7054 --caname ca.admin.credentials.com -M ${PWD}/../organizations/peerOrganizations/admin.credentials.com/users/Admin@admin.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/admin/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/admin.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/admin.credentials.com/users/Admin@admin.credentials.com/msp/config.yaml
}

createCertForUser() {
    echo
    echo "Enroll CA admin of User"
    echo
    mkdir -p ../organizations/peerOrganizations/user.credentials.com/
    export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/user.credentials.com/

    fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.user.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-user-credentials-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-user-credentials-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-user-credentials-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-user-credentials-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/config.yaml

    echo
    echo "Register peer0.user"
    echo

    fabric-ca-client register --caname ca.user.credentials.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    echo
    echo "Register peer1.user"
    echo

    fabric-ca-client register --caname ca.user.credentials.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    echo
    echo "Register user1.user"
    echo

    fabric-ca-client register --caname ca.user.credentials.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    echo
    echo "Register admin.user"
    echo

    fabric-ca-client register --caname ca.user.credentials.com --id.name org2admin --id.secret adminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    mkdir -p ../organizations/peerOrganizations/user.credentials.com/peers
    
    # -----------------------------------------------------------------------------------
    # Peer0
    mkdir -p ../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com

    echo
    echo "Generate Peer0 MSP"
    echo

    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.user.credentials.com -M ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/msp --csr.hosts peer0.user.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/msp/config.yaml

    echo
    echo "Generate Peer0 TLS-CERTs"
    echo

    fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.user.credentials.com -M ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls --enrollment.profile tls --csr.hosts peer0.user.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/ca.crt
    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/server.crt
    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/server.key

    mkdir ${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/tlscacerts
    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/tlscacerts/ca.crt

    mkdir ${PWD}/../organizations/peerOrganizations/user.credentials.com/tlsca
    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/tlsca/tlsca.user.credentials.com-cert.pem

    mkdir ${PWD}/../organizations/peerOrganizations/user.credentials.com/ca
    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer0.user.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/ca/ca.user.credentials.com-cert.pem

    # -----------------------------------------------------------------------------------
    # Peer1
    mkdir -p ../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com

    echo
    echo "Generate Peer1 MSP"
    echo

    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.user.credentials.com -M ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/msp --csr.hosts peer1.user.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/msp/config.yaml

    echo
    echo "Generate Peer1 TLS-CERTs"
    echo

    fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.user.credentials.com -M ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls --enrollment.profile tls --csr.hosts peer1.user.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/ca.crt
    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/server.crt
    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/server.key

    # mkdir ${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/tlscacerts
    # cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/tlscacerts/ca.crt

    # mkdir ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tlsca
    # cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/tlsca/tlsca.user.credentials.com-cert.pem

    # mkdir ${PWD}/../organizations/peerOrganizations/user.credentials.com/ca
    # cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/peers/peer1.user.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/user.credentials.com/ca/ca.user.credentials.com-cert.pem
    
    # ------------------------------------------------------------------------------------------
    mkdir -p ../organizations/peerOrganizations/user.credentials.com/users
    mkdir -p ../organizations/peerOrganizations/user.credentials.com/users/User1@user.credentials.com

    echo
    echo "Generate User1 MSP"
    echo
    fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.user.credentials.com -M ${PWD}/../organizations/peerOrganizations/user.credentials.com/users/User1@user.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    mkdir -p ../organizations/peerOrganizations/user.credentials.com/users/Admin@user.credentials.com

    echo
    echo "Generate User Admin MSP"
    echo

    fabric-ca-client enroll -u https://org2admin:adminpw@localhost:8054 --caname ca.user.credentials.com -M ${PWD}/../organizations/peerOrganizations/user.credentials.com/users/Admin@user.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/user/tls-cert.pem

    cp ${PWD}/../organizations/peerOrganizations/user.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/user.credentials.com/users/Admin@user.credentials.com/msp/config.yaml
}

# createCertForCommercialBank2() {
#     echo
#     echo "Enroll CA admin of CommercialBank2"
#     echo
#     mkdir -p ../organizations/peerOrganizations/commercialbank2.credentials.com/
#     export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/

#     fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca.commercialbank2.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     echo 'NodeOUs:
#   Enable: true
#   ClientOUIdentifier:
#     Certificate: cacerts/localhost-9054-ca-commercialbank2-credentials-com.pem
#     OrganizationalUnitIdentifier: client
#   PeerOUIdentifier:
#     Certificate: cacerts/localhost-9054-ca-commercialbank2-credentials-com.pem
#     OrganizationalUnitIdentifier: peer
#   AdminOUIdentifier:
#     Certificate: cacerts/localhost-9054-ca-commercialbank2-credentials-com.pem
#     OrganizationalUnitIdentifier: admin
#   OrdererOUIdentifier:
#     Certificate: cacerts/localhost-9054-ca-commercialbank2-credentials-com.pem
#     OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/config.yaml

#     echo
#     echo "Register peer0.commercialbank2"
#     echo

#     fabric-ca-client register --caname ca.commercialbank2.credentials.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     echo
#     echo "Register peer1.commercialbank2"
#     echo

#     fabric-ca-client register --caname ca.commercialbank2.credentials.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     echo
#     echo "Register user1.commercialbank2"
#     echo

#     fabric-ca-client register --caname ca.commercialbank2.credentials.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     echo
#     echo "Register admin.commercialbank2"
#     echo

#     fabric-ca-client register --caname ca.commercialbank2.credentials.com --id.name org3admin --id.secret adminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     mkdir -p ../organizations/peerOrganizations/commercialbank2.credentials.com/peers
    
#     # -----------------------------------------------------------------------------------
#     # Peer0
#     mkdir -p ../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com

#     echo
#     echo "Generate Peer0 MSP"
#     echo

#     fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.commercialbank2.credentials.com -M ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/msp --csr.hosts peer0.commercialbank2.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/msp/config.yaml

#     echo
#     echo "Generate Peer0 TLS-CERTs"
#     echo

#     fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.commercialbank2.credentials.com -M ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls --enrollment.profile tls --csr.hosts peer0.commercialbank2.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/ca.crt
#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/server.crt
#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/server.key

#     mkdir ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/tlscacerts
#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/tlscacerts/ca.crt

#     mkdir ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/tlsca
#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/tlsca/tlsca.commercialbank2.credentials.com-cert.pem

#     mkdir ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/ca
#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer0.commercialbank2.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/ca/ca.commercialbank2.credentials.com-cert.pem

#     # -----------------------------------------------------------------------------------
#     # Peer1
#     mkdir -p ../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com

#     echo
#     echo "Generate Peer1 MSP"
#     echo

#     fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.commercialbank2.credentials.com -M ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/msp --csr.hosts peer1.commercialbank2.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/msp/config.yaml

#     echo
#     echo "Generate Peer1 TLS-CERTs"
#     echo

#     fabric-ca-client enroll -u https://peer1:peer1pw@localhost:9054 --caname ca.commercialbank2.credentials.com -M ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls --enrollment.profile tls --csr.hosts peer1.commercialbank2.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/ca.crt
#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/server.crt
#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/server.key

#     # mkdir ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/tlscacerts
#     # cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/tlscacerts/ca.crt

#     # mkdir ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tlsca
#     # cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/tlsca/tlsca.commercialbank2.credentials.com-cert.pem

#     # mkdir ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/ca
#     # cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/peers/peer1.commercialbank2.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/ca/ca.commercialbank2.credentials.com-cert.pem

#     # ------------------------------------------------------------------------------------------
#     mkdir -p ../organizations/peerOrganizations/commercialbank2.credentials.com/users
#     mkdir -p ../organizations/peerOrganizations/commercialbank2.credentials.com/users/User1@commercialbank2.credentials.com

#     echo
#     echo "Generate User1 MSP"
#     echo
#     fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca.commercialbank2.credentials.com -M ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/users/User1@commercialbank2.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     mkdir -p ../organizations/peerOrganizations/commercialbank2.credentials.com/users/Admin@commercialbank2.credentials.com

#     echo
#     echo "Generate CommercialBank2 Admin MSP"
#     echo

#     fabric-ca-client enroll -u https://org3admin:adminpw@localhost:9054 --caname ca.commercialbank2.credentials.com -M ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/users/Admin@commercialbank2.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/commercialbank2/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/commercialbank2.credentials.com/users/Admin@commercialbank2.credentials.com/msp/config.yaml
    
# }

# createCertForGoodsCustomOrg4() {
#     echo
#     echo "Enroll CA admin of GoodsCustomOrg4"
#     echo
#     mkdir -p ../organizations/peerOrganizations/goodscustomorg4.credentials.com/
#     export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/

#     fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.goodscustomorg4.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     echo 'NodeOUs:
#   Enable: true
#   ClientOUIdentifier:
#     Certificate: cacerts/localhost-10054-ca-goodscustomorg4-credentials-com.pem
#     OrganizationalUnitIdentifier: client
#   PeerOUIdentifier:
#     Certificate: cacerts/localhost-10054-ca-goodscustomorg4-credentials-com.pem
#     OrganizationalUnitIdentifier: peer
#   AdminOUIdentifier:
#     Certificate: cacerts/localhost-10054-ca-goodscustomorg4-credentials-com.pem
#     OrganizationalUnitIdentifier: admin
#   OrdererOUIdentifier:
#     Certificate: cacerts/localhost-10054-ca-goodscustomorg4-credentials-com.pem
#     OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/config.yaml

#     echo
#     echo "Register peer0.goodscustomorg4"
#     echo

#     fabric-ca-client register --caname ca.goodscustomorg4.credentials.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     echo
#     echo "Register peer1.goodscustomorg4"
#     echo

#     fabric-ca-client register --caname ca.goodscustomorg4.credentials.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     echo
#     echo "Register user1.goodscustomorg4"
#     echo

#     fabric-ca-client register --caname ca.goodscustomorg4.credentials.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     echo
#     echo "Register admin.goodscustomorg4"
#     echo

#     fabric-ca-client register --caname ca.goodscustomorg4.credentials.com --id.name org4admin --id.secret adminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     mkdir -p ../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers
    
#     # -----------------------------------------------------------------------------------
#     # Peer0
#     mkdir -p ../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com

#     echo
#     echo "Generate Peer0 MSP"
#     echo

#     fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.goodscustomorg4.credentials.com -M ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/msp --csr.hosts peer0.goodscustomorg4.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/msp/config.yaml

#     echo
#     echo "Generate Peer0 TLS-CERTs"
#     echo

#     fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.goodscustomorg4.credentials.com -M ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls --enrollment.profile tls --csr.hosts peer0.goodscustomorg4.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/ca.crt
#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/server.crt
#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/server.key

#     mkdir ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/tlscacerts
#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/tlscacerts/ca.crt

#     mkdir ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/tlsca
#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/tlsca/tlsca.goodscustomorg4.credentials.com-cert.pem

#     mkdir ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/ca
#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer0.goodscustomorg4.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/ca/ca.goodscustomorg4.credentials.com-cert.pem

#     # -----------------------------------------------------------------------------------
#     # Peer1
#     mkdir -p ../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com

#     echo
#     echo "Generate Peer1 MSP"
#     echo

#     fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.goodscustomorg4.credentials.com -M ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/msp --csr.hosts peer1.goodscustomorg4.credentials.com --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/msp/config.yaml

#     echo
#     echo "Generate Peer1 TLS-CERTs"
#     echo

#     fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.goodscustomorg4.credentials.com -M ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls --enrollment.profile tls --csr.hosts peer1.goodscustomorg4.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/ca.crt
#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/server.crt
#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/server.key

#     # mkdir ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/tlscacerts
#     # cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/tlscacerts/ca.crt

#     # mkdir ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tlsca
#     # cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/tlsca/tlsca.goodscustomorg4.credentials.com-cert.pem

#     # mkdir ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/ca
#     # cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/peers/peer1.goodscustomorg4.credentials.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/ca/ca.goodscustomorg4.credentials.com-cert.pem

#     # ------------------------------------------------------------------------------------------
#     mkdir -p ../organizations/peerOrganizations/goodscustomorg4.credentials.com/users
#     mkdir -p ../organizations/peerOrganizations/goodscustomorg4.credentials.com/users/User1@goodscustomorg4.credentials.com

#     echo
#     echo "Generate User1 MSP"
#     echo
#     fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.goodscustomorg4.credentials.com -M ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/users/User1@goodscustomorg4.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     mkdir -p ../organizations/peerOrganizations/goodscustomorg4.credentials.com/users/Admin@goodscustomorg4.credentials.com

#     echo
#     echo "Generate GoodsClientOrg4 Admin MSP"
#     echo

#     fabric-ca-client enroll -u https://org4admin:adminpw@localhost:10054 --caname ca.goodscustomorg4.credentials.com -M ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/users/Admin@goodscustomorg4.credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/goodscustomorg4/tls-cert.pem

#     cp ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/goodscustomorg4.credentials.com/users/Admin@goodscustomorg4.credentials.com/msp/config.yaml
    
# }

createCretificateForOrderer() {
  echo
  echo "Enroll CA admin of Orderer"
  echo
  mkdir -p ../organizations/ordererOrganizations/credentials.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/ordererOrganizations/credentials.com

  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../organizations/ordererOrganizations/credentials.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer2"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer3"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register the Orderer Admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  mkdir -p ../organizations/ordererOrganizations/credentials.com/orderers
  # mkdir -p ../organizations/ordererOrganizations/credentials.com/orderers/credentials.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com

  echo
  echo "Generate the Orderer MSP"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/msp --csr.hosts orderer.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/msp/config.yaml

  echo
  echo "Generate the orderer TLS Certs"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls --enrollment.profile tls --csr.hosts orderer.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/ca.crt
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/signcerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/server.crt
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/keystore/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/server.key

  mkdir ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/msp/tlscacerts/tlsca.credentials.com-cert.pem

  mkdir ${PWD}/../organizations/ordererOrganizations/credentials.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/msp/tlscacerts/tlsca.credentials.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com

  echo
  echo "Generate the Orderer2 MSP"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/msp --csr.hosts orderer2.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/msp/config.yaml

  echo
  echo "Generate the Orderer2 TLS Certs"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls --enrollment.profile tls --csr.hosts orderer2.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls/ca.crt
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls/signcerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls/server.crt
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls/keystore/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls/server.key

  mkdir ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer2.credentials.com/msp/tlscacerts/tlsca.credentials.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com

  echo
  echo "Generate the Orderer3 MSP"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/msp --csr.hosts orderer3.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/msp/config.yaml

  echo
  echo "Generate the Orderer3 TLS certs"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:11054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls --enrollment.profile tls --csr.hosts orderer3.credentials.com --csr.hosts localhost --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls/ca.crt
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls/signcerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls/server.crt
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls/keystore/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls/server.key

  mkdir ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/msp/tlscacerts
  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/tls/tlscacerts/* ${PWD}/../organizations/ordererOrganizations/credentials.com/orderers/orderer3.credentials.com/msp/tlscacerts/tlsca.credentials.com-cert.pem
  # ---------------------------------------------------------------------------

  mkdir -p ../organizations/ordererOrganizations/credentials.com/users
  mkdir -p ../organizations/ordererOrganizations/credentials.com/users/Admin@credentials.com

  echo
  echo "Generate the Admin MSP Orderer"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:11054 --caname ca-orderer -M ${PWD}/../organizations/ordererOrganizations/credentials.com/users/Admin@credentials.com/msp --tls.certfiles ${PWD}/../organizations/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../organizations/ordererOrganizations/credentials.com/msp/config.yaml ${PWD}/../organizations/ordererOrganizations/credentials.com/users/Admin@credentials.com/msp/config.yaml

}

createCertForAdmin
createCertForUser
createCretificateForOrderer