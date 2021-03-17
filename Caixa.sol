// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.4.22 < 0.7.0;

contract Caixa {

    struct Product {
        bytes32 productHash;  // Hash do produto
        uint price;
    }

    struct Sale {
        bytes32 saleHash;
        bytes32 productHash;
        uint quantity;
        uint totalPaid;
    }

    Product[] public products;
    Sale[] public sales;

    function add(bytes32 productHash, uint price) public returns(bool) {
        products.push(Product({
            productHash: productHash,
            price: price
        }));

        return true;
    }

    function remove(bytes32 productHash) public returns(bool) {
        uint index = getIndexByHash(productHash);

        delete products[index];
        
        return true;
    }

    function getIndexByHash(bytes32 productHash) private view returns(uint) {
        for (uint i = 0; i < products.length; i++){
            if(products[i].productHash == productHash) {
                return i;
            }
        }
    }

    function sell(bytes32 productHash, uint quantity) public payable returns(bytes32) {
        uint productPrice = getProductPrice(productHash);
        
        uint total = quantity * productPrice;
        
        require(msg.value >= total, "Insufficient funds");
        
        //gerando hash de transacao com o address remetente, address destino e a quantidde de tokens
        bytes32 saleHash = keccak256(abi.encodePacked(msg.sender, msg.value, block.timestamp));
        sales.push(Sale({
            saleHash: saleHash,
            productHash: productHash,
            quantity: quantity,
            totalPaid: msg.value
        }));
        return saleHash;
    }
    
    function getProductPrice(bytes32 productHash) private view returns(uint) {
        for (uint i = 0; i < products.length; i++){
            if(products[i].productHash == productHash) {
                return products[i].price;
            }
        }
        
        return 0;
    }

}