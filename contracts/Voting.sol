// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
contract Voting is Ownable, ERC20 {
    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;
    address public numberVote; 
    Counters.Counter private counter;
    constructor() ERC20 ("ACBank", "ACB")
    {
      _mint(msg.sender, 100000000000000000000000000);
    }
    struct Topic
    {
      uint startTimeVote;
      uint endTimeVote;
      uint id;  
    }
    Topic[] public topicArray;
    function setTokenVote (address addressContract) external onlyOwner
    {
      numberVote = addressContract;
    }
    function createTopic (uint256 startTime, uint endTime) external onlyOwner{
      Topic memory topic;
      topic.startTimeVote = startTime;
      topic.endTimeVote = endTime;
      topic.id = counter.current();
      topicArray.push(topic);
      counter.increment();
    }
    function viewTopic(uint256 Index) public view returns(Topic memory topic){
      topic = topicArray[Index];
    }
    function voteAgree(uint256 Index, uint256 amount) external {
      Topic storage topic = topicArray[Index];
      require(topic.endTimeVote >= block.timestamp, "Topic da dong");
      require(IERC20(numberVote).balanceOf(msg.sender) >= amount, "Khong du tai san de vote");
      IERC20(numberVote).safeTransferFrom(msg.sender, address(this), amount);   
  }

  function voteDontAgree(uint256 Index, uint256 amount) external{
    Topic storage topic = topicArray[Index];
    require(topic.endTimeVote >= block.timestamp, "Topic da dong");
    require(IERC20(numberVote).balanceOf(msg.sender) >= amount, "Khong du tai san de vote");
    IERC20(numberVote).safeTransferFrom(msg.sender, address(this), amount);    
  }
}
