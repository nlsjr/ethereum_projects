// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.4.22 < 0.7.0;

contract LivroCaixa {

    struct Pessoa{
        string cpf;
        bytes32 documentoHash;
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
        string content;
        bytes32 registerHash;
    }

    Pessoa[] public pessoas;
    Movimentacao[] public movimentacoes;
    
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
    function addPessoa(string memory cpf, bytes32 documentoHash) public returns(bool) {
        require(!verifyPessoa(documentoHash), "Pessoa already exists.");

        pessoas.push(Pessoa({
            cpf: cpf,
            documentoHash: documentoHash,
            owner: msg.sender
        }));

        return true;
    }

    /*
        Funcao responsavel por verificar se a pessoa ja existe no contrato
    */
    function verifyPessoa(bytes32 documentoHash) private view returns(bool) {
        for (uint i = 0; i < pessoas.length; i++){
            if(pessoas[i].documentoHash == documentoHash) {
                return true;
            }
        }
        return false;
    }

    /*
        Funcao responsavel por realizar a movimentacao no caixa
        Obs: Toda movimentacao sera gerado um hash unico que poderá ser buscado posteriormente
             Somente o register pode realizar um lancamento no caixa
    */
    function addToCaixa(bytes32 origem, bytes32 destino, uint value, string memory content) public onlyRegister returns(bytes32) {
        address addressOrigem = getAddressByHash(origem);
        address addressDestino = getAddressByHash(destino);

        bytes32 registerHash = keccak256(abi.encodePacked(msg.sender, addressOrigem, addressDestino, value, block.timestamp));

        movimentacoes.push(Movimentacao({
            register: msg.sender,
            pessoaOrigem: addressOrigem,
            pessoaDestino: addressDestino,
            valorMovimentado: value,
            content: content,
            registerHash: registerHash
        }));

        return registerHash;
    }

    /*
        Funcao responsavel por obter o endereco da pessoa pelo hash do documento
    */
    function getAddressByHash(bytes32 documentoHash) private view returns(address) {
        for (uint i = 0; i < pessoas.length; i++){
            if(pessoas[i].documentoHash == documentoHash) {
                return pessoas[i].owner;
            }
        }
    }
    
    /*
        Funcao responsavel por retornar o cpf pelo endereco informado
    */
    function verifyCpf(address ownerCpf) public view returns(string memory) {
        for (uint i = 0; i < pessoas.length; i++){
            if(pessoas[i].owner == ownerCpf) {
                return pessoas[i].cpf;
            }
        }
    }
    
    /*
        Funcao responsavel por listar todos os hashes de movimentacoes através da carteira de origem informada
    */
    function listMovimentacoes(address origem) public view returns(bytes32[] memory registerHashes) {
        bytes32[] memory registers = new bytes32[](movimentacoes.length);
        
        for (uint i = 0; i < movimentacoes.length; i++){
            if(movimentacoes[i].pessoaOrigem == origem) {
                registers[i] = movimentacoes[i].registerHash;
            }
        }
        
        return registers;
    }
    
    /*
        Funcao responsavel por alterar o register do contrato
        Obs: Somente o dono do contrato pode alterar o register
    */
    function setRegister(address newRegister) public onlyOwner {
        register = newRegister;
    }
}