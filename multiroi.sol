// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface assetERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function decimal() external returns(uint256);
    function transferFrom(address from, address to, uint tokens) external  returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ROI{

    assetERC20 token;
    address tokenOwner;
    // uint reward;

    constructor(assetERC20 tokenAddress){

        token = tokenAddress;
        tokenOwner = msg.sender;
    }

    struct Stakers {
        uint256[] investedTokens;
        uint256[] startTime;
        uint256 claimedAt;
        uint256[] totalProfit;
        uint256[] reward;
        uint256[] profit_withdrawn;
        bool[] timeStarted;
    }

    
    mapping (address => Stakers)  stakerINfo;    
    address[] public stakeraddress;
    event claimed(address claimer, uint amount, uint time);
    
    function stackTokens(uint amount) public {
        // require(token.balanceOf(msg.sender)> 0,"your balance is insufficient");
        // Stakers storage data = stakerINfo[msg.sender];
        // require(stakerINfo[msg.sender].timeStarted.push == false,"your time is already started");
        stakerINfo[msg.sender].startTime.push(block.timestamp);
        stakerINfo[msg.sender].timeStarted.push(true);
        stakerINfo[msg.sender].claimedAt = block.timestamp;
        stakerINfo[msg.sender].investedTokens.push(amount);
        stakerINfo[msg.sender].profit_withdrawn.push(0);
        // token.transferFrom(msg.sender, tokenOwner, amount);
        stakerINfo[msg.sender].totalProfit.push((amount * 180)/100);
        stakerINfo[msg.sender].reward.push((amount *6)/100); 
        stakeraddress.push(msg.sender);
    }

    function withDraw() public {
        // Stakers storage data = stakerINfo[msg.sender];
        for(uint index=0 ; index < stakerINfo[msg.sender].startTime.length; index++){
        require(stakerINfo[msg.sender].timeStarted[index] == true,"you are not a stakeholder");
        uint a = stakerINfo[msg.sender].reward[index]/1;
        // stakerINfo[msg.sender].claimedAt = block.timestamp;
        if(stakerINfo[msg.sender].totalProfit[index] > stakerINfo[msg.sender].profit_withdrawn[index]){
        // uint256 duration = stakerINfo[msg.sender].profit / 86400;
        uint256 currentduration = (block.timestamp - stakerINfo[msg.sender].claimedAt);
        uint256 _profit = a * currentduration;
        
        if(_profit +stakerINfo[msg.sender].profit_withdrawn[index] > stakerINfo[msg.sender].totalProfit[index]){
           uint256 remProfit =stakerINfo[msg.sender].totalProfit[index] - stakerINfo[msg.sender].profit_withdrawn[index];
        //    token.transferFrom(tokenOwner,msg.sender, remProfit);
           stakerINfo[msg.sender].claimedAt = block.timestamp;

        //    uint claimedAt = block.timestamp;       
           stakerINfo[msg.sender].profit_withdrawn[index] = stakerINfo[msg.sender].profit_withdrawn[index] + remProfit;
        } 
        else{
            // token.transferFrom(tokenOwner,msg.sender, _profit); 
            stakerINfo[msg.sender].claimedAt = block.timestamp;
            stakerINfo[msg.sender].profit_withdrawn[index] =stakerINfo[msg.sender].profit_withdrawn[index] + _profit;
        }
        
        
        }   


        
        }
    }

    function timeExtend() public view returns (uint){
        
        uint256 currentduration = (block.timestamp - stakerINfo[msg.sender].claimedAt);
        return currentduration;
    }

    function getAdd() public view returns (address[] memory){
        return stakeraddress;
    }

    function getData(address add) public view returns(uint256[] memory,uint256[] memory ,
    uint256,uint256[] memory,
    uint256[] memory,uint256[] memory, 
    bool[] memory){
        return (stakerINfo[add].investedTokens,stakerINfo[add].startTime,
        stakerINfo[add].claimedAt,stakerINfo[add].totalProfit,
        stakerINfo[add].reward,stakerINfo[add].profit_withdrawn,
        stakerINfo[add].timeStarted);
    }   
}
