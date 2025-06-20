// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lottery{
    //Declaring and initializing the state variables
    address[] public participants;
    address public owner;
    uint256 public constant entry_fee = 0.01 ether;
    uint256 public constant max_participants = 10;

    //Event to declare the winner
    event AnnounceWinner(address winner, uint winnerPrize);

    constructor(){
        //Declaring the contract owner as the lottery owner
        owner = msg.sender;
    }

    modifier onlyOwner() {
        //Restricting the access only to the owner
        require(msg.sender == owner,"Accessible only to the owner.");
        _;
    }

    function participate() public payable {
        //Checking the requirements
        require(msg.value == entry_fee, "Please send exact value of 0.01 ETH");
        require(participants.length < max_participants, "Lottery is full!");

        participants.push(msg.sender);
        //The participant is added to the lottery

        //Choose winner as soon as the lottery is full
        if (participants.length == max_participants) {
            declareWinner();
        }
    }

    function declareWinner() private {
        //Choose random winner
        uint randomIndex = block.timestamp % participants.length;

        address winner = participants[randomIndex];

        uint balance = address(this).balance;
        uint winnerPrize = (balance * 90) / 100;
        uint ownerCharge = balance - winnerPrize;

        //Conduct the transfer
        payable(winner).transfer(winnerPrize);
        payable(owner).transfer(ownerCharge);

        //Declaring Winner using event
        emit AnnounceWinner( winner , winnerPrize);
    }

    //Displays the particiants list
    function getParticipants() public view returns(address[] memory) {
        return participants;
    }

    function resetLottery() public{
        delete participants;
    }
}