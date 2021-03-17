pragma solidity >= 0.4.22 < 0.7.0;

contract SGE {
    struct SCarros {
        string Placa;
        uint Entrada;
        uint Saida;
    }

    address owner;
    address[] gerentes;
    uint ticket;
    mapping(uint => SCarros) public carros;

    constructor() public {
        owner = msg.sender;
        ticket = 0;
    }

    function addGerente(address gerente) public {
        require(msg.sender == owner, "Voce nao pode adicionar gerentes");
        gerentes.push(gerente);
    }

    function validarGerente(address) public view returns(bool valido) {
        for(uint i=0; i < gerentes.length; i++) {
            if(gerentes[i] == gerente) return true;
        }
        return false;
    }

    function addCar(string memory placa) public returns(uint returned_ticket) {
        require(validarGerente(msg.sender), "Voce nao e um gerente");
        ticket = ticket + 1;
        carros[ticket].Placa = placa;
        carros[ticket].Entrada = block.timestamp;//so conseguimos acessar o timestamp do bloco
        return ticket;
    }

    function calcularValor(uint received_ticket) public view returns(uint preco) {
        return block.timestamp - carros[received_ticket].Entrada;
    }

    function removeCar(uint received_ticket) public {
        require(validarGerente(msg.sender), "Voce nao e um gerente");
        delete carros[received_ticket];
    }
}