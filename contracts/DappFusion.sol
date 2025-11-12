// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DappFusion
 * @dev A decentralized application registry that allows developers to publish, update, 
 *      and retrieve DApp metadata securely on the blockchain.
 */
contract DappFusion {
    struct Dapp {
        string name;
        string description;
        address owner;
        uint256 createdAt;
    }

    uint256 public dappCount;
    mapping(uint256 => Dapp) private dapps;

    event DappPublished(uint256 indexed id, string name, address indexed owner, uint256 timestamp);
    event DappUpdated(uint256 indexed id, string newDescription, uint256 timestamp);

    /**
     * @dev Publish a new DApp with its name and description.
     * @param name The name of the decentralized application.
     * @param description A short description of the DApp.
     */
    function publishDapp(string memory name, string memory description) public {
        dappCount++;
        dapps[dappCount] = Dapp(name, description, msg.sender, block.timestamp);
        emit DappPublished(dappCount, name, msg.sender, block.timestamp);
    }

    /**
     * @dev Update the description of a DApp that you own.
     * @param id The ID of the DApp to update.
     * @param newDescription The new description text.
     */
    function updateDapp(uint256 id, string memory newDescription) public {
        require(id > 0 && id <= dappCount, "Invalid DApp ID");
        require(dapps[id].owner == msg.sender, "Not the owner");
        dapps[id].description = newDescription;
        emit DappUpdated(id, newDescription, block.timestamp);
    }

    /**
     * @dev Retrieve details of a specific DApp.
     * @param id The DApp ID.
     * @return name The name of the DApp.
     * @return description The description of the DApp.
     * @return owner The address of the DApp owner.
     * @return createdAt The timestamp when the DApp was published.
     */
    function getDapp(uint256 id)
        public
        view
        returns (string memory name, string memory description, address owner, uint256 createdAt)
    {
        require(id > 0 && id <= dappCount, "Invalid DApp ID");
        Dapp memory dapp = dapps[id];
        return (dapp.name, dapp.description, dapp.owner, dapp.createdAt);
    }
}
