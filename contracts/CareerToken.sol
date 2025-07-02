// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CareerToken is ERC20, Ownable {
    mapping(address => bool) public authorized;
    
    event AchievementRewarded(address indexed user, uint256 amount, string achievement);
    event StakingReward(address indexed user, uint256 amount);
    
    constructor() ERC20("Career Token", "CAREER") {
        _mint(msg.sender, 1000000000 * 10**decimals()); // 1B tokens
    }
    
    function rewardAchievement(
        address user, 
        uint256 amount, 
        string memory achievement
    ) external {
        require(authorized[msg.sender], "Not authorized");
        _mint(user, amount);
        emit AchievementRewarded(user, amount, achievement);
    }
    
    function setAuthorized(address account, bool status) external onlyOwner {
        authorized[account] = status;
    }
    
    function distributeStakingRewards(address[] memory users, uint256[] memory amounts) external onlyOwner {
        require(users.length == amounts.length, "Arrays length mismatch");
        
        for (uint i = 0; i < users.length; i++) {
            _mint(users[i], amounts[i]);
            emit StakingReward(users[i], amounts[i]);
        }
    }
}
