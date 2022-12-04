//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
contract lottery{
    address public owner;
    uint public price;
    uint public f=0;
    constructor(){
        owner=msg.sender;
        price=3;
    }

    mapping(uint=>address) public lotteryNoToAddress;
    uint public i=0;
    uint public k=0;

    function buyLottery()payable public {
        require(f==0,"Lottery has ended");
        require(msg.value>=3 ether,"Not Sufficient funds");
        require(msg.value%3==0,"Amount should be in multiple of 3 to buy valid ticket");
        uint tickets=(msg.value)/(3 ether);
        for(uint j=0;j<tickets;j++){
            lotteryNoToAddress[i]=msg.sender;
            i++;
        }
        k++;
    }

    function random(uint num) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, 
    msg.sender))) % num;
    }

    function declareWinner() public returns(address){
        require(f==0,"Winner already declared");
        require(msg.sender==owner,"Only owner can declare Winner");
        require(k>=3,"Atleast 3 people should buy lottery");
        f=1;
        uint x= random(i);
        uint y=(address(this).balance)/10;
        payable(lotteryNoToAddress[x]).transfer(address(this).balance-y);
        payable(owner).transfer(y);
        return lotteryNoToAddress[x];
    }
}