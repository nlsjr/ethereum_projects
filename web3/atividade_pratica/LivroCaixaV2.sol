// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.4.22 < 0.7.0;

contract LivroCaixaV2 {

    struct Pessoa{
        address owner;
    }
    
    address public owner;
    address public register;
    
    constructor(address newRegister) public {
        owner = msg.sender;
        register = newRegister;
    }

    struct Movimentacao {
        address register;
        address pessoaOrigem;
        address pessoaDestino;
        uint valorMovimentado;
        bytes32 registerHash;
    }

    mapping (string => Pessoa) public pessoas;
    mapping (bytes32 => Movimentacao) public movimentacoes;
    mapping (address => bytes32[]) public movimentacaoList;
    
    address[] public movimentacaoAddresses;
    
    modifier onlyOwner {
        require(msg.sender == owner, "Permission denied.");
        _;
    }
    
    modifier onlyRegister {
        require(msg.sender == register, "Permission denied.");
        _;
    }

    /*
        Funcao responsavel por adicionar uma pessoa ao contrato
        Obs: Essa pessoa será usada posteriormente para as movimentacoes do caixa
             A carteira correspondente deve ser dono do cpf e o hash do documento
    */
    function addPessoa(string memory cpf, address personAddress) public onlyRegister returns(bool) {
        require(!verifyPessoa(cpf), "Pessoa already exists.");
        
        pessoas[cpf].owner = personAddress;

        return true;
    }

    /*
        Funcao responsavel por verificar se a pessoa ja existe no contrato
    */
    function verifyPessoa(string memory cpf) private view returns(bool) {
        return pessoas[cpf].owner != address(0);
    }

    /*
        Funcao responsavel por realizar a movimentacao no caixa
        Obs: Toda movimentacao sera gerado um hash unico que poderá ser buscado posteriormente
             Somente o register pode realizar um lancamento no caixa
    */
    function addToCaixa(string memory cpfOrigem, string memory cpfDestino, uint value, bytes32 contentHash) public onlyRegister returns(bytes32) {
        address addressOrigem = getAddressByCpf(cpfOrigem);
        address addressDestino = getAddressByCpf(cpfDestino);

        bytes32 registerHash = keccak256(abi.encodePacked(msg.sender, addressOrigem, addressDestino, value, block.timestamp));

        movimentacoes[contentHash].register = msg.sender;
        movimentacoes[contentHash].pessoaOrigem = addressOrigem;
        movimentacoes[contentHash].pessoaDestino = addressDestino;
        movimentacoes[contentHash].valorMovimentado = value;
        movimentacoes[contentHash].registerHash = registerHash;
        
        movimentacaoList[addressOrigem].push(registerHash);

        return registerHash;
    }
    

    /*
        Funcao responsavel por obter o endereco da pessoa pelo hash do documento
    */
    function getAddressByCpf(string memory cpf) private view returns(address) {
        return pessoas[cpf].owner;
    }

    
    /*
        Funcao responsavel por listar todos os hashes de movimentacoes através da carteira de origem informada
    */
    function listMovimentacoes(address origem) public view returns(bytes32[] memory registerHashes) {
        return movimentacaoList[origem];
    }
    
    /*
        Funcao responsavel por alterar o register do contrato
        Obs: Somente o dono do contrato pode alterar o register
    */
    function setRegister(address newRegister) public onlyOwner {
        register = newRegister;
    }
}