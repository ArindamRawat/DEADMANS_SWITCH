// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public ownerAddress;
    address public designatedRecipientAddress;
    uint256 public lastCheckedBlockNumber;

    constructor(address _recipient) {
        ownerAddress = msg.sender;
        designatedRecipientAddress = _recipient;
        lastCheckedBlockNumber = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress, "Only the owner can call this function");
        _;
    }

    modifier onlyRecipient() {
        require(msg.sender == designatedRecipientAddress, "Only the designated recipient can call this function");
        _;
    }

    function stillAlive() external onlyOwner {
        lastCheckedBlockNumber = block.number;
    }

    function withdrawFunds() external onlyOwner {
        require(block.number - lastCheckedBlockNumber >= 10, "The owner is still alive.");
        uint256 contractBalance = address(this).balance;
        payable(ownerAddress).transfer(contractBalance);
    }
}
