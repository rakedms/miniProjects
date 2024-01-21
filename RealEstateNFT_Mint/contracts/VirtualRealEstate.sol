// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract VirtualRealEstate is ERC721URIStorage, Ownable {
    mapping (uint => string) public TokenURI;
    uint TokenID=0;
    event minted(address indexed to, uint indexed TokenID);

     constructor() 
        ERC721('RealEstateToken', 'RET') 
        Ownable(msg.sender) {}

    function mintWithURI(address _to, string memory _tokenURI) external onlyOwner {
        TokenID = TokenID + 1;
        _safeMint(_to, TokenID);
        
        TokenURI[TokenID] = _tokenURI;
        // return TokenID;
        emit minted(_to, TokenID);
    }

    function getTokenURI(uint _TokenID) external view returns(string memory) {
        return TokenURI[_TokenID]; 
    }


}
