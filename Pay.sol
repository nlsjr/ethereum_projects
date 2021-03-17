pragma solidity >= 0.4.22 < 0.7.0;

contract Pay {
    uint public total;

    address payable owner;

    constructor() public {
        owner = msg.sender;
        total = 0;
    }

    function receive() public payable {
        total = total + msg.value;
        //sempre importante ter um pouco mais do valor desejado da transferencia
        //por causa do custo do gas
        if(total > 1 ether) {
            owner.transfer(1 ether);
        }
    }

    //funcao de fallback
    function () external payable {
        total = total - msg.value;
    }
}