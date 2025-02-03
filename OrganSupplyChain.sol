// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrganSupplyChain {
    enum OrganState { Died, Harvested, Packaged, Transit, Delivered, SurgeryOngoing, Implanted }

    struct Organ {
        OrganState state;
        address currentOwner;
    }

    mapping (uint256 => Organ) organs;

    event OrganStateChanged(uint256 indexed organId, OrganState newState);

    modifier onlyOwner(uint256 organId) {
        require(organs[organId].currentOwner == msg.sender, "Only organ owner can perform this action");
        _;
    }

    function getOrganState(uint256 organId) public view returns (OrganState) {
        return organs[organId].state;
    }

    function harvestOrgan(uint256 organId) public {
        organs[organId].state = OrganState.Harvested;
        organs[organId].currentOwner = msg.sender;
        emit OrganStateChanged(organId, OrganState.Harvested);
    }

    function packageOrgan(uint256 organId) public onlyOwner(organId) {
        require(organs[organId].state == OrganState.Harvested, "Organ must be harvested first");
        organs[organId].state = OrganState.Packaged;
        emit OrganStateChanged(organId, OrganState.Packaged);
    }

    function sendOrganToTransit(uint256 organId) public onlyOwner(organId) {
        require(organs[organId].state == OrganState.Packaged, "Organ must be packaged first");
        organs[organId].state = OrganState.Transit;
        emit OrganStateChanged(organId, OrganState.Transit);
    }

    function deliverOrgan(uint256 organId) public onlyOwner(organId) {
        require(organs[organId].state == OrganState.Transit, "Organ must be in transit first");
        organs[organId].state = OrganState.Delivered;
        emit OrganStateChanged(organId, OrganState.Delivered);
    }

    function startSurgery(uint256 organId) public onlyOwner(organId) {
        require(organs[organId].state == OrganState.Delivered, "Organ must be delivered first");
        organs[organId].state = OrganState.SurgeryOngoing;
        emit OrganStateChanged(organId, OrganState.SurgeryOngoing);
    }

    function implantOrgan(uint256 organId) public onlyOwner(organId) {
        require(organs[organId].state == OrganState.SurgeryOngoing, "Surgery must be ongoing first");
        organs[organId].state = OrganState.Implanted;
        emit OrganStateChanged(organId, OrganState.Implanted);
    }

    // Fallback function to reject Ether sent to this contract
    receive() external payable {
        revert("This contract does not accept Ether");
    }
}
