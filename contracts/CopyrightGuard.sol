// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract CopyrightGuard {
    address public owner;
    
    enum WorkType { Literary, Musical }
    
    struct Work {
        address creator;
        WorkType workType;
        string description;
        uint256 timestamp;
        bool exists;
    }

    mapping(uint256 => Work) public works;

    event WorkRegistered(
        uint256 indexed id,
        address indexed creator,
        WorkType workType,
        string description,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerWork(
        uint256 id,
        WorkType workType,
        string memory description
    ) external {
        require(!works[id].exists, "Work ID already exists");
        works[id] = Work(msg.sender, workType, description, block.timestamp, true);
        emit WorkRegistered(id, msg.sender, workType, description, block.timestamp);
    }

    function verifyAuthenticity(uint256 id) external view returns (
        address creator,
        WorkType workType,
        string memory description,
        uint256 timestamp
    ) {
        require(works[id].exists, "Work ID does not exist");
        return (works[id].creator, works[id].workType, works[id].description, works[id].timestamp);
    }

    function monitorUsage(uint256 id) external view returns (uint256 timestamp) {
        require(works[id].exists, "Work ID does not exist");
        return works[id].timestamp;
    }

    function transferOwnership(uint256 id, address newOwner) external onlyOwner {
        require(works[id].exists, "Work ID does not exist");
        works[id].creator = newOwner;
    }
}
