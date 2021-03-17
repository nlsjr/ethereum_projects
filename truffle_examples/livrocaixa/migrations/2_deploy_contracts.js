const TestToken = artifacts.require("TestToken");

module.exports = function(deployer) {
    //Primeiro argumento é o contrato
    //Segundo argumento é o parametro esperado pelo contrato
    deployer.deploy(TestToken, 10000);
}