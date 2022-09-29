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
        uint256[] totalProfit;
        uint256[] reward;
        uint256[] profit_withdrawn;
        bool[] timeStarted;
    }

    mapping (address => Stakers)  stakerINfo;    
    
    function stackTokens(uint amount) public {
        require(token.balanceOf(msg.sender)> 0,"your balance is insufficient");
        // Stakers storage data = stakerINfo[msg.sender];
        // require(stakerINfo[msg.sender].timeStarted.push == false,"your time is already started");
        stakerINfo[msg.sender].startTime.push(block.timestamp);
        stakerINfo[msg.sender].timeStarted.push(true);
        stakerINfo[msg.sender].investedTokens.push(amount);
        token.transferFrom(msg.sender, tokenOwner, amount);
        stakerINfo[msg.sender].totalProfit.push((amount * 180)/100);
        stakerINfo[msg.sender].reward.push((amount *6)/100); 
    }

    function withDraw() public {
        // Stakers storage stakerINfo[msg.sender] = stakerINfo[msg.sender];
        for(uint index=0 ; index <= stakerINfo[msg.sender].startTime.length; index++){
        require(stakerINfo[msg.sender].timeStarted[index] == true,"you are not a stakeholder");
        uint a = stakerINfo[msg.sender].reward[index] /10;
        if(stakerINfo[msg.sender].totalProfit[index] > stakerINfo[msg.sender].profit_withdrawn[index]){
        // uint256 duration = stakerINfo[msg.sender].profit / 86400;
        uint256 currentduration = (block.timestamp - stakerINfo[msg.sender].startTime[index]);
        uint256 _profit = a * currentduration;
        
        if(_profit +stakerINfo[msg.sender].profit_withdrawn[index] > stakerINfo[msg.sender].totalProfit[index]){
           uint256 remProfit =stakerINfo[msg.sender].totalProfit[index] - stakerINfo[msg.sender].profit_withdrawn[index];
           token.transferFrom(tokenOwner,msg.sender, remProfit);
           stakerINfo[msg.sender].profit_withdrawn[index] = stakerINfo[msg.sender].profit_withdrawn[index] + remProfit;
        } 
        else{
            token.transferFrom(tokenOwner,msg.sender, _profit); 
            stakerINfo[msg.sender].profit_withdrawn[index] =stakerINfo[msg.sender].profit_withdrawn[index] + _profit;
        }
    }

}
    }
}
