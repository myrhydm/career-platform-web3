// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CareerAchievements is ERC721, Ownable {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIdCounter;
    mapping(address => bool) public authorized;
    mapping(uint256 => AchievementData) public achievements;
    
    struct AchievementData {
        string achievementType;
        string description;
        uint256 timestamp;
        uint256 score;
        string metadata;
    }
    
    event AchievementMinted(address indexed user, uint256 tokenId, string achievementType);
    
    constructor() ERC721("Career Achievements", "ACHIEVE") {}
    
    function mintAchievement(
        address to,
        string memory achievementType,
        string memory description,
        uint256 score,
        string memory metadata
    ) external returns (uint256) {
        require(authorized[msg.sender], "Not authorized");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        achievements[tokenId] = AchievementData({
            achievementType: achievementType,
            description: description,
            timestamp: block.timestamp,
            score: score,
            metadata: metadata
        });
        
        _safeMint(to, tokenId);
        emit AchievementMinted(to, tokenId, achievementType);
        
        return tokenId;
    }
    
    function setAuthorized(address account, bool status) external onlyOwner {
        authorized[account] = status;
    }
    
    function getAchievement(uint256 tokenId) external view returns (AchievementData memory) {
        require(_exists(tokenId), "Achievement does not exist");
        return achievements[tokenId];
    }
}
