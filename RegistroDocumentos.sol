pragma solidity 0.5.11;

contract RegistroDocumentos {
    mapping(bytes32 => address) documentos;
    uint256 public arrecadacao;
    address payable dono;
    bool private interrompeRegistro = false;
    
    constructor() public {
        dono = msg.sender;
    }
    
    modifier apenasDono {
        require(msg.sender == dono, "Apenas o dono!");
        _;
    }
    
    modifier incrementarArrecadacao {
        arrecadacao += msg.value;
        _;
    }
    
     modifier registroInterrompido {
        require(!interrompeRegistro, "Registros suspensos!");
        _;
    }
    
    function registrarDocumento(bytes32 hashDocumento) public incrementarArrecadacao registroInterrompido payable {
        require(msg.value >= 0.0001 ether, "Valor insuficiente");
        documentos[hashDocumento] = msg.sender;
    }
    
    function verificarDocumento(bytes32 hashDocumento) public incrementarArrecadacao registroInterrompido payable returns(bool){
        require(msg.value >= 0.00001 ether, "Valor insuficiente");
        return documentos[hashDocumento] != address(0);
    }
    
    function descobrirQuemRegistrou(bytes32 hashDocumento) public incrementarArrecadacao registroInterrompido payable returns(address){
        require(msg.value >= 0.00001 ether, "Valor insuficiente");
        return documentos[hashDocumento];
    }
    
    function sacar() public apenasDono{
        dono.transfer(arrecadacao);
        arrecadacao = 0;
    }
    
    function interromperRegistro() public apenasDono {
        interrompeRegistro = true;
    }
}