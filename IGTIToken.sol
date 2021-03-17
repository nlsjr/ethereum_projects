pragma solidity >= 0.4.22 < 0.7.0;

contract IGTIToken {
    string public constant name = "IGTIToken";
    string public constant symbol = "IGTI";
    uint8 public constant decimais = 8;

    mapping (address => uint) balances;

    //array bidimensional
    //vai ser usado para o ICO
    mapping (address => mapping(address => uint)) allowed;

    //usando lib Math criada para todos os uints
    using Math for uint;

    uint totalSuply;

    //owner quem esta aprovando
    //spender quem esta gastando
    event Approve(address owner, address spender, uint tokens);
    event Transfer(address from, address to, uint tokens);

    constructor (uint total) public {
        balances[msg.sender] = total;
        totalSuply = total;
    }

    function TotalSuply() public view returns (uint) {
        return totalSuply;
    }

    function balanceOf(address token) public view returns(uint){
        return balances[token];
    }

    //aprovando quem pode negociar meu token durante ICo por exemplo
    function approve(address delegate, uint tokens) public returns(bool){
        //verificando se ha tokens
        require(balances[msg.sender] <= tokens, "Insufficient funds");
        allowed[msg.sender][delegate].add(tokens);
        emit Approve(msg.sender, delegate, tokens);
        return true;
    }

    //a quantidade de tokens que uma corretora pode vender ex: a binance pode vender durante meu ICO por exemplo
    function allowance(address owner, address delegate) public view returns(uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address receiver, uint tokens) public returns(bool) {
        //verificando o saldo de quem esta enviando o token(owner)
        require(allowed[owner][msg.sender] <= tokens, "Insufficient funds");
        require(balances[msg.sender] <= tokens, "Insufficient funds");
       
        balances[msg.sender].sub(tokens);
        allowed[owner][msg.sender].sub(tokens);
        balances[receiver].add(tokens);

        emit Transfer(msg.sender, receiver, tokens);

        return true;
    }

    function transfer(address receiver, uint tokens) public returns(bool){
        require(balances[msg.sender] <= tokens, "Insufficient funds");
        balances[msg.sender].sub(tokens);
        balances[receiver].add(tokens);
    }


}

//criando biblioteca matematica
library Math {
    function add(uint a, uint b) internal pure returns(uint){
        uint c = a + b;
        assert(c >= a);
        return c;
    }

    function sub(uint a, uint b)internal pure returns(uint) {
        assert(b <= a);
        return a - b;
    }
}