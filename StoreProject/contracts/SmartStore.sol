// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SmartStoreToken.sol";
import "./SmartStoreBillNFT.sol";

contract SmartStore {
    address public StoreOwner = 0x00954daD9F16fB218B2E696666C8766CBba47d93; //here I am considiering this address as the Store Owner
    SmartStoreToken public BuyToken;
    SmartStoreBill public BillToken;
    address BuyTokenAddress = 0x3D016ce097cfd71Bd29661A5D5E2FCc9051797A9; //address of deployed token contract
    address BillTokenAddress = 0xcd8d60d0B0aD05f5E53810998d60f84a0dA00089; //address of BillNFT token

    struct Details{
        string Name;
        uint32 Price;
    }

    mapping(uint256 => bool) public productBoughtStatus;
    mapping(uint256 => Details) public ProductDetails;
    mapping(uint256 => mapping(address => uint256)) public ProductBillDetails;

    event ProductPurchased(address indexed buyer, uint256 indexed productId);
    event BillGenerated(address indexed buyer, uint256 indexed billNo);

    constructor() { 
        BuyToken = SmartStoreToken(BuyTokenAddress);
        BillToken = SmartStoreBill(BillTokenAddress);
    }

    function purchaseProduct(address _buyer, uint256 productID, uint32 _price, string memory _ProductName) external returns(uint256){
        require(!productBoughtStatus[productID], "Product Already Bought");

        productBoughtStatus[productID] = true;
        ProductDetails[productID] = Details(_ProductName, _price);
        require(BuyToken.allowance(_buyer, address(this)) >= _price, "Insufficient Allowance, Approve amount in Token Contract");

        require(BuyToken.transferFrom(_buyer, StoreOwner, _price), "Token Transfer Failed");  // Transfer tokens to the owner
        uint256 BillNo = BillToken.mintBill(
                            _buyer, 
                            productID, 
                            _ProductName, 
                            _price);

        ProductBillDetails[productID][_buyer] = BillNo;

        emit ProductPurchased(_buyer, productID); 
        emit BillGenerated(_buyer, BillNo);

        return(BillNo);
    }
}

// contract address: 0x049299fd3f12c8136B68E94fF971A78264C1289F

