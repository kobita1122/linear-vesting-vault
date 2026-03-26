// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract VestingWallet is Ownable, ReentrancyGuard {
    IERC20 public immutable token;
    address public immutable beneficiary;
    
    uint256 public immutable start;
    uint256 public immutable cliff;
    uint256 public immutable duration;
    
    uint256 public released;
    bool public revoked;

    event TokensReleased(uint256 amount);
    event VestingRevoked();

    constructor(
        address _token,
        address _beneficiary,
        uint256 _start,
        uint256 _cliffDuration,
        uint256 _duration
    ) Ownable(msg.sender) {
        require(_beneficiary != address(0), "Beneficiary is zero address");
        require(_cliffDuration <= _duration, "Cliff longer than duration");
        
        token = IERC20(_token);
        beneficiary = _beneficiary;
        start = _start;
        cliff = _start + _cliffDuration;
        duration = _duration;
    }

    function release() public nonReentrant {
        uint256 releasable = vestedAmount() - released;
        require(releasable > 0, "No tokens due");

        released += releasable;
        token.transfer(beneficiary, releasable);

        emit TokensReleased(releasable);
    }

    function vestedAmount() public view returns (uint256) {
        uint256 totalAllocation = token.balanceOf(address(this)) + released;

        if (block.timestamp < cliff) {
            return 0;
        } else if (block.timestamp >= start + duration || revoked) {
            return totalAllocation;
        } else {
            return (totalAllocation * (block.timestamp - start)) / duration;
        }
    }

    function revoke() external onlyOwner {
        require(!revoked, "Already revoked");
        
        uint256 releasable = vestedAmount() - released;
        if (releasable > 0) {
            release();
        }

        uint256 unvested = token.balanceOf(address(this));
        token.transfer(owner(), unvested);
        
        revoked = true;
        emit VestingRevoked();
    }
}
