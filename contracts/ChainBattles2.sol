// SPDX-License-Identifier: MIT

// contract deployd to 0xCa4219d37e5FDd968eD6F9544B4add6c0848B97e
// 0xA100193043e5AA189125eE24814965F1D567636a
//0x7092eC872a314c6E0212eA222e53f1e5982facf3
//0xe0fb0c0e110136B242b875DcE913e86017fBE45D
//0x66bAF40993f7917821964C4bc5C7419AA3D833Ea
//0xc38DaB51491F90411668314A79B5Ff0F7f2Aa462


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles2 is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    //uint256 initialNumber = 0;

    struct NFT_LEVELS { 
      uint256 Level;
      uint256 Speed;
      uint256 Strength;
      uint256 Life;
   } 

    mapping(uint256 => NFT_LEVELS) public tokenIdToLevels;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    // This is were the NFT will be generated //

    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevels(tokenId),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
            '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}

    

    function getLevels(uint256 tokenId) public view returns (string memory) {
         NFT_LEVELS memory _level= tokenIdToLevels[tokenId];
        return _level.Level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        NFT_LEVELS memory _level = tokenIdToLevels[tokenId];
        return _level.Speed.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        NFT_LEVELS memory _level = tokenIdToLevels[tokenId];
        return _level.Strength.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        NFT_LEVELS memory _level = tokenIdToLevels[tokenId];
        return _level.Life.toString();
    }


function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",', // we're using the tokenId to generate the name of the token/NFT, appending the tokenId to the string chain battles # tokenId
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"', // we're using the generateCharacter function to generate the image of the token/NFT associated with the tokenId
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}



function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    NFT_LEVELS storage _level = tokenIdToLevels[newItemId];
    _level.Level = 1;
    _level.Speed = 4;
    _level.Strength = 3;
    _level.Life = 1;    
    
    //tokenIdToLevels[newItemId] = Levels(random(10), random(50), random(20), random(3));
    _setTokenURI(newItemId, getTokenURI(newItemId));
}

function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing Token");
    require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");


    NFT_LEVELS storage _level = tokenIdToLevels[tokenId];

    uint256 currentLevel = _level.Level;
    _level.Level = currentLevel + 1;

    uint256 currentSpeed = _level.Speed;
    _level.Speed = currentSpeed + getRandomNumber(currentSpeed);

    uint256 currentStrength = _level.Strength;
    _level.Strength = currentStrength + getRandomNumber(currentStrength);

    uint256 currentLife = _level.Life;
    _level.Life = currentLife + getRandomNumber(currentStrength);


    /*tokenIdToLevels[tokenId].Level = currentLevel + 1;
    tokenIdToLevels[tokenId].Speed = random(100);
    tokenIdToLevels[tokenId].Strength = random(100);
    tokenIdToLevels[tokenId].Life = random(100);*/

    _setTokenURI(tokenId, getTokenURI(tokenId));
    
    }

    function getRandomNumber(uint256 max) public view returns (uint256) {
        bytes memory seed = abi.encodePacked(block.timestamp,block.difficulty,msg.sender);
        uint256 rand = random(seed,max);
        return rand;
    }
     
    
    
    function random(bytes memory _seed, uint256 max) private pure returns (uint256) {
        return uint256(keccak256(_seed)) % max;        
    }

}