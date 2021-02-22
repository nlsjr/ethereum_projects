pragma solidity 0.5.11;

contract Conteudo {
    string[] private frases;
    address public dono;
    
    constructor() public {
        dono = msg.sender;
    }
    
    modifier apenasDono {
        require(msg.sender == dono);
        _;
    }
    
    function adicionarFrase(string memory frase) public apenasDono {
        frases.push(frase);    
    }
    
    function obterTotalDeFrases() public view returns (uint) {
        return frases.length;
    }
    
    function obterFrases(uint indice) public view returns(string memory) {
        if(frases.length<=0) {
            return "sem ideias no momento";
        } else if(indice > (frases.length-1)) {
            return frases[frases.length-1];
        } else {
            return frases[indice];
        }
    }
    
    function removerFrase(uint index) public  {
        if (index >= frases.length) return;

        for (uint i = index; i<frases.length-1; i++){
            frases[i] = frases[i+1];
        }
        
        frases.length--;
    }
}