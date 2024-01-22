// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;



import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SmartStoreBill is ERC721 {
    uint256 public billNo;

    struct ProductBill{
        uint256 id;
        string name;
        uint32 price;
    } 

    mapping (uint256 => mapping(address => ProductBill)) public Bills;
    event BillMinted(address indexed buyer, uint256 indexed productId, uint256 indexed billId);

    constructor() ERC721("SmartStoreBill", "SSB") {}
    
    function mintBill(
        address buyer, 
        uint256 productId, 
        string memory productName, 
        uint32 productPrice) external returns (uint256) {
        
        _safeMint(buyer, productId);
        billNo++;
        emit BillMinted(buyer, productId, billNo);
        Bills[billNo][buyer] = ProductBill(productId, productName, productPrice);
        return billNo;
    
    }

    function getDetails(uint256 BillId,address buyer) public view returns(ProductBill memory){
        return (Bills[BillId][buyer]);
    }
}

//contract address : 0xcd8d60d0B0aD05f5E53810998d60f84a0dA00089

//contract address after edited for backend: 0xdB9340A35C34b0e6d4172d6B841C1c57c4503e1c
