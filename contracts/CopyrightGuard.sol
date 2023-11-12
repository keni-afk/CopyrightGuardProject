// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CopyrightGuard {
    address public owner;
    mapping(uint256 => address) public owners;
    mapping(uint256 => string) public works;

    event WorkRegistered(uint256 indexed id, address indexed owner, string work);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerWork(uint256 id, string memory work) external {
        require(owners[id] == address(0), "Work ID already exists");
        owners[id] = msg.sender;
        works[id] = work;
        emit WorkRegistered(id, msg.sender, work);
    }

    function transferOwnership(uint256 id, address newOwner) external onlyOwner {
        require(owners[id] == msg.sender, "Not the owner of the work");
        owners[id] = newOwner;
    }
}
