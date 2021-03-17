// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.4.22 < 0.7.0;

contract BetHighLow {

    // todos os uints tem as funcoes habilitadas que estao criadas em Math
    using Math for uint;

    struct Bet {
        address player;
        uint value;
        bool direction;
    }

    uint comission = 0.00001 ether;

    mapping(address => uint) public balances;

    Bet[] public bets;

    uint house;

    // rolas os dados
    // algoritmo que gera numero aleatorio
    function Dice(address player, uint value) public pure returns(uint) {
        uint random = uint(keccak256(abi.encodePacked(player, value))) % 99999;
        random = random + 10000;
        return random;
    }

    //fazer aposta
    //valor minimo de aposta
    function DoBet(bool direction) public payable returns(uint) {
        require(msg.value > 0.001 ether, "Valor não permitido");

        balances[msg.sender] = balances[msg.sender].add(msg.value);

        Bet memory newBet;

        newBet.player = msg.sender;
        newBet.value = msg.value;
        newBet.direction = direction;

        if(bets.length > 0) {
            uint codeBet = ProcessBet(bets[0], newBet);
            delete bets[0];
            return codeBet;
        } else {
            bets.push(newBet);
        }

    }

    function Withdrawal(uint value) public payable {
        require(balances[msg.sender] >= value, "Insufficient funds");
        balances[msg.sender] = balances[msg.sender].sub(value);
        msg.sender.transfer(value);
    }

    function() external payable {
        house.add(msg.value);
    }

    function minVal(uint n1, uint n2) internal pure returns(uint{
        if(n1 <= n2) return n1;
        if(n2 < n1) return n2;
    }

    // processar a aposta
    //interna pq é processamento interno da aposta
    function ProcessBet(Bet memory stored, Bet memory newBet) internal returns(uint) {
        bool storedWin = false;
        bool newWin = false;

        uint storedDice = Dice(storedBet.player, storedBet.value);
        uint newDice = Dice(newBet.player, newBet.value);

        if(storedDice > newDice && storedBet.direction == true) storedWin = true;
        if(storedDice < newDice && storedBet.direction == false) storedWin = true;
        if(newDice > storedDice && newBet.direction == true) newWin = true;
        if(newDice < storedDice && newBet.direction == false) newWin = true;

        //empate
        if((storedWin && newWin) || (!storedWin && !newWin)) {
            return 1;
        }

        uint gain = minVal(storedBet.value, newBet.value);
        house.add(comission);
        if(storedWin) {
            balances[soredBet.player] = balances[storedBet.player].add(gain.sub(comission));
            balances[newBet.player] = balances[newBet.player].sub(gain);
            return 2;
        }

        if(newWin) {
            balances[newBet.player] = balances[newBet.player].add(gain.sub(comission));
            balances[storedBet.player] = balances[storedBet.player].sub(gain);
            return 3;
        }

    }
}

library Math {
    function sub(uint x, uint y) internal pure returns(uint) {
        assert(y <= x);
        return x - y;
    }

    function add(uint x, uint y) internal pure returns(uint) {
        uint c = x + y;
        assert(c > 0);
        return c;
    }
}