pragma solidity 0.5.11;

contract Custodia {
    address payable public pagador;//payable deixa claro que essa variavel pode enviar ou receber ETH 
    address payable public recebedor;
    address public arbitro;
    uint256 public valor;
    bool public custodiaEmAndamento;
    
    //evento disparado com as informacoes necessarias
    event NovaCustodia(address solicitante, address arbitro, address recebedor, uint256 valor);
    
    function iniciarCustodia(address novoArbitro, address payable novoRecebedor) public payable {
        require(!custodiaEmAndamento, "Custodia em andamento");
        custodiaEmAndamento = true;
        valor = msg.value;
        pagador = msg.sender;
        arbitro = novoArbitro;
        recebedor = novoRecebedor;
        
        emit NovaCustodia(msg.sender, arbitro, recebedor, msg.value);
    }
    
    function pagar() public {
        require(msg.sender == arbitro, "Apenas o arbitro");
        recebedor.transfer(valor);
        
        //voltando as variaveis ao estado original
        custodiaEmAndamento = false;
        valor = 0;
        arbitro = address(0);
        pagador = address(0);
        recebedor = address(0);
    }
    
    function devolver() public {
        require(msg.sender == arbitro, "Apenas o arbitro!");
        pagador.transfer(valor);
        
        //voltando as variaveis ao estado original
        custodiaEmAndamento = false;
        valor = 0;
        arbitro = address(0);
        pagador = address(0);
        recebedor = address(0);
    }
}