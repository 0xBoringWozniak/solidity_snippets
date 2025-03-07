// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Product {
    uint256 public price;
    uint256 public amount;
    string public name;

    constructor(uint256 _price, uint256 _amount, string memory _name) {
        price = _price;
        amount = _amount;
        name = _name;
    }
}

contract ProductFactory {
    Product[] public deployedProducts;

    event ContractDeployed(address indexed productAdress);

    function createProduct(uint256 price, uint256 amount, string memory name) external {
        Product newProduct = new Product(price, amount, name);
        deployedProducts.push(newProduct);
        emit ContractDeployed(address(newProduct));
    }

    function getDeployedProducts() external view returns (Product[] memory) {
        return deployedProducts;
    }
}
