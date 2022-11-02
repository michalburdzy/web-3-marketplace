pragma solidity ^0.6.0;

contract Marketplace {
    struct Product {
        uint id;
        string name;
        uint price;
        address owner;
        bool purchased;
    }
    string public name;
    mapping(uint => Product) public products;
    uint public productCount = 0;

    event ProductCreated(
        uint id,
        string name,
        uint price,
        address owner,
        bool purchased
    );

    event ProductPurchased(
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Simple Blockchain Marketplace";
    }

    function createProduct(string memory _name, uint _price) public {
        require(bytes(_name).length > 0, "Product name cannot be empty");
        require(_price > 0, 'Price cannot be "0"');

        productCount++;
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );

        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint _id) public payable {
        Product memory _product = products[_id];
        address payable _seller = payable(_product.owner);
        // address payable _seller = _product.owner;

        require(
            _product.id > 0 && _product.id <= productCount,
            "No such product"
        );
        require(
            msg.value >= _product.price,
            "You are sending unsufficient funds to purchase this product"
        );
        require(!_product.purchased, "Product is already purchased");
        require(_seller != msg.sender, "You cannot but your own product");

        _product.owner = msg.sender;
        _product.purchased = true;
        products[_id] = _product;
        payable(address(_seller)).transfer(msg.value);

        emit ProductPurchased(
            productCount,
            _product.name,
            _product.price,
            msg.sender,
            true
        );
    }
}
