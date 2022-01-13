// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol"; 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol"; 

contract SeaPetsToken is ERC721, Ownable {
       constructor(string memory name_, string memory symbol_) 
        ERC721(name_, symbol_)
    {}

    uint256 COUNTER; 

    uint256 fee = 1 ether; 
    
    struct Seapet {
        string name; 
        uint256 id; 
        uint256 dna; 
        uint8 level; 
        uint8 rarity; 
    }

    Seapet[] public Seapets; 

    event NewSeapet(address indexed owner, uint256 id, uint256 dna);

    //Helpers
    function _createRandomNum(uint256 _mod) internal view returns(uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))); 
        return randomNum % _mod; 
    } 

    function updateFee(uint256 _fee) external onlyOwner() {
        fee = _fee; 
    }

    
    function withdraw() external payable onlyOwner() {
        address payable _owner = payable(owner()); 
        _owner.transfer(address(this).balance); 
    }
 
    // Creation
    function _createSeapet(string memory _name) internal {
       uint256 randDna = _createRandomNum(10**16);
       uint8 randRarity =  uint8(_createRandomNum(100)); 
       Seapet memory newSeapet = Seapet(_name, COUNTER, randDna, 1, randRarity); 
       Seapets.push(newSeapet); 
       _safeMint(msg.sender,COUNTER);
       emit NewSeapet(msg.sender, COUNTER, randDna);
       COUNTER++;  
       
    }

    function createRandomSeapet(string memory _name) public payable {
        require(msg.value == fee); 
        _createSeapet(_name); 
    }

    //Getters
    function getSeapets() public view returns(Seapet[] memory){
        return Seapets; 
    }

    function getFee() public view returns(uint256) {
        return fee; 
    }


}
