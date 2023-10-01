// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address public designatedRecipient;
    uint256 public lastCheckedBlock;

    constructor(address _recipient) {
        owner = msg.sender;
        designatedRecipient = _recipient;
        lastCheckedBlock = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyRecipient() {
        require(msg.sender == designatedRecipient, "Only the designated recipient can call this function");
        _;
    }

    function stillAlive() external onlyOwner {
        lastCheckedBlock = block.number;
    }

    function withdrawFunds() external onlyOwner {
        require(block.number - lastCheckedBlock >= 10, "The owner is still alive.");
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }
}