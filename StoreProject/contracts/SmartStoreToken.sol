// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SmartStoreToken is ERC20 {
    constructor() ERC20("SamrtStoreToken", "SST") {
        _mint(address(this), 1000000); // Initial supply, adjust as needed
    }
    
    event Transferred (address from, address to, uint32 amt);

    //not more than 1000000 since it the the totalSupply
    function transferToken(address _to, uint32 _amt) external {             
        _transfer(address(this), _to, _amt);
        emit Transferred(address(this), _to, _amt);
    }

    function approvePurchase(address _SmartStoreAddress, uint32 _amt) public {
        approve(_SmartStoreAddress, _amt);
    }
}

//address : 0x3D016ce097cfd71Bd29661A5D5E2FCc9051797A9
