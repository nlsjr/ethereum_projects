pragma solidity >= 0.4.22 < 0.7.0;

contract Token1 {
    mapping(address => uint) public accounts;

    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendToken(address to, uint amount) public returns (byte32) {
        require(accounts[msg.sender] > amount, 'Insufficients funds');
        accounts[msg.sender] -= amount;
        accounts[to] += amount;
        //gerando hash de transacao com o address remetente, address destino e a quantidde de tokens
        return keccak256(abi.encodePacked(msg.sender, to, amount));
    }

    function createTokens(uint amount) public {
        require(msg.sender == owner, "Permission denied.");
        accounts[owner] += amount;
    }
}