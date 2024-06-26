// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract BuyMeABeerContract {
    uint256 totalBeer;
    address payable public owner;

    constructor(Item[] memory initialItems) payable {
        owner = payable(msg.sender);
        for (uint256 i = 0; i < initialItems.length; i++) {
            items.push(Item({
                id: nextItemId,
                name: initialItems[i].name,
                imageUrl: initialItems[i].imageUrl,
                price: initialItems[i].price,
                enabled: initialItems[i].enabled
            }));
            emit ItemAdded(nextItemId, initialItems[i].name, initialItems[i].imageUrl, initialItems[i].price, initialItems[i].enabled);
            nextItemId++;
        }
    }

    event NewBeer(
        address indexed from,
        uint256 timestamp,
        string message,
        string name
    );

    struct Beer {
        address sender;
        string message;
        string name;
        uint256 timestamp;
    }

    Beer[] beer;

    function getAllBeer() public view returns (Beer[] memory) {
        return beer;
    }

    function getTotalBeer() public view returns (uint256) {
        return totalBeer;
    }

    function buyBeer(
        string memory _message,
        string memory _name
    ) payable public {
        require(msg.value == 0.01 ether, "You should give me 0.01");

        totalBeer += 1;
        beer.push(Beer(msg.sender, _message, _name, block.timestamp));

        (bool success,) = owner.call{value: msg.value}("");
        require(success, "Failed to send Ether to owner");

        emit NewBeer(msg.sender, block.timestamp, _message, _name);
    }

    // Item Management
    struct Item {
        uint256 id;
        string name;
        string imageUrl;
        uint256 price;
        bool enabled;
    }

    Item[] public items;
    uint256 public nextItemId;

    event ItemAdded(uint256 id, string name, string imageUrl, uint256 price, bool enabled);
    event ItemUpdated(uint256 id, string name, string imageUrl, uint256 price, bool enabled);
    event ItemEnabled(uint256 id, bool enabled);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    function addItem(string memory _name, string memory _imageUrl, uint256 _price) public onlyOwner {
        items.push(Item(nextItemId, _name, _imageUrl, _price, true));
        emit ItemAdded(nextItemId, _name, _imageUrl, _price, true);
        nextItemId++;
    }

    function updateItem(uint256 _id, string memory _name, string memory _imageUrl, uint256 _price) public onlyOwner {
        require(_id < nextItemId, "Item does not exist");
        Item storage item = items[_id];
        item.name = _name;
        item.imageUrl = _imageUrl;
        item.price = _price;
        emit ItemUpdated(_id, _name, _imageUrl, _price, item.enabled);
    }

    function enableItem(uint256 _id, bool _enabled) public onlyOwner {
        require(_id < nextItemId, "Item does not exist");
        items[_id].enabled = _enabled;
        emit ItemEnabled(_id, _enabled);
    }

    function getItem(uint256 _id) public view returns (Item memory) {
        require(_id < nextItemId, "Item does not exist");
        return items[_id];
    }

    function deleteItem(uint256 _id) public onlyOwner {
        require(_id < nextItemId, "Item does not exist");
        delete items[_id];
    }

    function getAllItems() public view returns (Item[] memory) {
        return items;
    }
}
