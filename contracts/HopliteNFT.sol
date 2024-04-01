// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@layerzerolabs/solidity-examples/contracts/token/onft721/ONFT721.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IHopliteNFT.sol";


contract HopliteNFT is Ownable, ONFT721, ERC2981, IHopliteNFT {
    uint256 public constant MAX_SUPPLY = 5000;

    string public baseTokenURI;

    address public royaltyHandler;

    mapping(address => bool) public whiteList;

    uint256 public goLiveDate;

    // Max 10% royalty
    uint256 private constant MAX_ROYALTY = 1000;

    constructor (
        string memory baseURI,
        uint256 _goLiveDate,
        uint _minGasToTransfer,
        address _lzEndpoint
    ) ONFT721("Mozaic Hoplites", "HOP", _minGasToTransfer, _lzEndpoint) {
        setBaseURI(baseURI);
        goLiveDate = _goLiveDate;
        whiteList[msg.sender] = true;
        for(uint256 i=0; i<377; i++) {
            _mint(msg.sender, i);
        }
        whiteList[msg.sender] = false;
    }

    /*//////////////////////////////////////////////////////////////
                       Error
    //////////////////////////////////////////////////////////////*/
    error NotWhiteList();

    /*//////////////////////////////////////////////////////////////
                       Events
    //////////////////////////////////////////////////////////////*/

    event NewDefaultRoyalty(address receiver, uint256 newRoyalty);
    event NewTokenRoyalty(uint256 tokenId, address receiver, uint256 newRoyalty);
    event DeleteDefaultRoyalty();
    event ResetTokenRoyalty(uint256 tokenId);
    event UpdateGoLiveDate(uint256 newLiveDate);
}