// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract ConstruToken is ERC20 {
    string public SYMBOL = "CTK";
    string public NAME = "CTK";
    uint8 public DECIMALS = 18;
    uint256 public INITIAL_SUPPLY = 1000000000000000000000000;

    address public owner;
    uint256 public quote;

    constructor() ERC20(NAME, SYMBOL) {
        owner = msg.sender;
        _mint(owner, INITIAL_SUPPLY);
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner!");
        _;
    }

    function _beforeTokenTransfer( address from,address to,uint256 amount) internal override(ERC20) {}

    function setQuote(uint256 quoteValue) onlyOwner public{
        quote = quoteValue*(1 ether); //transformando em wei
    }
    
    function getQuote() public view returns (uint256) {
        return quote/(1 ether); //transformando em ether
    }
    
    
    function totalBalance() private view returns(uint256) {
        return balanceOf(owner);
    }
    
    function buy(uint numTokens) public payable returns (bool) {
        uint256 necessaryWei = quote * numTokens;
        
        require(necessaryWei <= msg.value, "insufficient funds");
        require(numTokens <= totalBalance(), "number of requested tokens greater than balance!");
        
        _transfer(owner, msg.sender, numTokens);
        return true;
    }

} 