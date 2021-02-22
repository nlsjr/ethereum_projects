pragma solidity 0.5.11;

contract RegistroDocumentos {

    struct Register {
        address owner; // Dono do documento
        bytes32 documentHash;  // Hash do documento
        uint256 balance;
    }
    
    Register[] public registers;
    address payable dono;
    bool private interrompeRegistro = false;
    
    constructor() public {
        dono = msg.sender;
    }
    
    modifier apenasDono {
        require(msg.sender == dono, "Apenas o dono!");
        _;
    }
    
     modifier registroInterrompido {
        require(!interrompeRegistro, "Registros suspensos!");
        _;
    }
    
    modifier saldoSuficiente {
        require((getBalance(msg.sender) >= 0.0001 ether) || (msg.value >= 0.0001 ether), "Saldo insuficiente!");
        _;
    }
    
    function registrarDocumento(bytes32 hashDocumento) public saldoSuficiente registroInterrompido payable {
        registers.push(Register({
            owner: msg.sender,
            documentHash: hashDocumento,
            balance: msg.value
        }));
    }
    
    function verificarDocumento(bytes32 hashDocumento) public saldoSuficiente registroInterrompido payable returns(bool){
        return getOwner(hashDocumento) != address(0);
        
    }
    
    function descobrirQuemRegistrou(bytes32 hashDocumento) public saldoSuficiente registroInterrompido payable returns(address){
        return getOwner(hashDocumento);
    }
    
    function sacar() public apenasDono{
        //dono.transfer(arrecadacao);
        //arrecadacao = 0;
    }
    
    function interromperRegistro() public apenasDono {
        interrompeRegistro = true;
    }
    
    function getOwner(bytes32 documentHash) private view returns(address) {
        for (uint reg = 0; reg < registers.length; reg++) {
            if (registers[reg].documentHash == documentHash) {
                return registers[reg].owner;
            }
        }   
    }
    
    function getBalance(address owner) public view returns(uint256) {
        for (uint reg = 0; reg < registers.length; reg++) {
            if (registers[reg].owner == owner) {
                return registers[reg].balance;
            }
        }     
    }
}