// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Staking
{
    // Interface to interact with staking Token and Reward Token.
    ERC20 stakingToken;
    ERC20 rewardToken;

    address public owner;


    uint256 public StakeDuration;                   //Minimum Stake Duration.
    uint256 public EndTime;                         //Time when the Stake Duration Ends.                     
    uint256 public LastUpdatetime;                  //Last Time user Interacted with the contract.
    uint256 public RewardRate;                      // Tokens minted per second/duration.
    uint256 public RewardsperToken;                 // Total rewards for the duration of Token staked.
    mapping(address => uint) public UserRewardperToken; // Total rewards per User when they first interacted with the smart contract.
    mapping(address => uint) public Rewards;        // Mapping to hold rewards per user.  
    mapping(address => uint) public Balances;       //Mapping to hold how much each user has staked
    uint256 public TotalSupply;                     //Total Staked amount in the contract


    modifier OnlyOwner() 
    {
        require(msg.sender == owner,"Aborting, You are not the Owner");
        _;
    }

    modifier UpdateReward(address _account)
    {
        RewardsperToken = rewardperTokenCalc();
        LastUpdatetime = LastTimeRewardApplicable();
        if(_account != address(0))
        {
            Rewards[_account] = RewardEarned(_account);
            UserRewardperToken[_account] = RewardsperToken;
        }
        _;
    }


    constructor(address _StakedToken, address _RewardToken)
    {
        owner = msg.sender;
        stakingToken = ERC20(_StakedToken);
        rewardToken = ERC20(_RewardToken);
    }


    function rewardperTokenCalc() public view returns(uint256)
    {
        if(TotalSupply == 0)
        {
            return RewardsperToken;
        }
        return RewardsperToken + (RewardRate * (LastTimeRewardApplicable() - LastUpdatetime) * 1e18) / TotalSupply;
    }

    function SetDuration(uint _duration) external OnlyOwner   //Till when the rewards will be distributed.
    {
        require(block.timestamp > EndTime,"Reward Duration Not Finished");
        StakeDuration = _duration;
    }

    function SetRewardAmount(uint _amount) external OnlyOwner UpdateReward(address(0)) //Owner has to specify the total number of Reward Tokens.
    {
        if(block.timestamp > EndTime)        
        {
            RewardRate = _amount/StakeDuration;
        }
        else
        {
            uint RemainingRewards = RewardRate*(EndTime-block.timestamp);
            RewardRate = (RemainingRewards + _amount) / StakeDuration;
        }
        require(RewardRate > 0,"Reward Rate Cannot be Zero");
        require(RewardRate*StakeDuration <= rewardToken.balanceOf(address(this)),"Reward Rate is greater than balance");
        EndTime = block.timestamp + StakeDuration;
        LastUpdatetime = block.timestamp;
    }
          
    function StakeTokens(uint _Amount) external UpdateReward(msg.sender)
    {
        require(_Amount > 0, "Amount Cannot be Zero");
        stakingToken.transferFrom(msg.sender, address(this), _Amount);
        Balances[msg.sender] += _Amount;
        TotalSupply += _Amount;
    }

    function Withdraw(uint _Amount) external UpdateReward(msg.sender)
    {
        require(_Amount > 0, "Amount Cannot be Zero" );
        Balances[msg.sender] -= _Amount;
        TotalSupply -= _Amount;
        stakingToken.transfer(msg.sender, _Amount);
    }

    function ClaimRewards() external UpdateReward(msg.sender)
    {
        uint reward = Rewards[msg.sender];
        if(reward>0)
        {
            Rewards[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
        }
    }
    //Function to calculate the Rewards Earned.
    function RewardEarned(address _Account) public view returns(uint)
    {
        return ((Balances[_Account] * (rewardperTokenCalc() - UserRewardperToken[_Account])) / 1e18) + Rewards[_Account];
    }
    //Function to return the last time when reward should be given to the user.
    function LastTimeRewardApplicable() public view returns(uint)
    {
        return(min(block.timestamp,EndTime));
    }

    function min(uint x, uint y) private pure returns(uint)
    {
        return x < y ? x : y;
    }
      
}

interface ERC20
{
    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
}

