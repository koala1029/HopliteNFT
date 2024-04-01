// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface IHopliteNFT {
    function setBaseURI(string memory baseURI) external;
    // function setRoyaltyHandler(address _handler) external;
    // function adjustRoyalty(uint96 newRoyalty) external;
    function updateWhiteList(address[] memory _whiteListUsers) external;
    function removeWhiteList(address[] memory _whiteListUsers) external;

    // function updateGoLiveDate(uint256 _newLiveDate) external;
}
