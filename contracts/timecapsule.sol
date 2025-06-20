// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract DecentralizedTimeCapsule {
    struct TimeCapsule {
        address creator;
        string message;
        uint256 unlockTime;
        bool isUnlocked;
        bool exists;
    }
    
    mapping(uint256 => TimeCapsule) public timeCapsules;
    mapping(address => uint256[]) public userCapsules;
    uint256 public capsuleCounter;
    
    event CapsuleCreated(uint256 indexed capsuleId, address indexed creator, uint256 unlockTime);
    event CapsuleUnlocked(uint256 indexed capsuleId, address indexed unlocker);
    
    modifier onlyAfterUnlockTime(uint256 _capsuleId) {
        require(block.timestamp >= timeCapsules[_capsuleId].unlockTime, "Time capsule is still locked");
        _;
    }
    
    modifier capsuleExists(uint256 _capsuleId) {
        require(timeCapsules[_capsuleId].exists, "Time capsule does not exist");
        _;
    }
    
    function createTimeCapsule(string memory _message, uint256 _unlockTime) external {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");
        require(bytes(_message).length > 0, "Message cannot be empty");
        
        capsuleCounter++;
        
        timeCapsules[capsuleCounter] = TimeCapsule({
            creator: msg.sender,
            message: _message,
            unlockTime: _unlockTime,
            isUnlocked: false,
            exists: true
        });
        
        userCapsules[msg.sender].push(capsuleCounter);
        
        emit CapsuleCreated(capsuleCounter, msg.sender, _unlockTime);
    }
    
    function unlockTimeCapsule(uint256 _capsuleId) 
        external 
        capsuleExists(_capsuleId) 
        onlyAfterUnlockTime(_capsuleId) 
        returns (string memory) 
    {
        require(!timeCapsules[_capsuleId].isUnlocked, "Time capsule already unlocked");
        
        timeCapsules[_capsuleId].isUnlocked = true;
        
        emit CapsuleUnlocked(_capsuleId, msg.sender);
        
        return timeCapsules[_capsuleId].message;
    }
    
    function getTimeCapsuleInfo(uint256 _capsuleId) 
        external 
        view 
        capsuleExists(_capsuleId) 
        returns (address creator, uint256 unlockTime, bool isUnlocked) 
    {
        TimeCapsule memory capsule = timeCapsules[_capsuleId];
        return (capsule.creator, capsule.unlockTime, capsule.isUnlocked);
    }
    
    function getUserCapsules(address _user) external view returns (uint256[] memory) {
        return userCapsules[_user];
    }
}
