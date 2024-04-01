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

     /*//////////////////////////////////////////////////////////////
                       Configuration
    //////////////////////////////////////////////////////////////*/

    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }

    /*//////////////////////////////////////////////////////////////
                        Tweaks
    //////////////////////////////////////////////////////////////*/

    function setDefaultRoyalty(address receiver, uint96 newRoyalty) public onlyOwner {
        require(newRoyalty <= MAX_ROYALTY, "Too high royalty");
        _setDefaultRoyalty(receiver, newRoyalty);
        emit NewDefaultRoyalty(receiver, newRoyalty);
    }

    function deleteDefaultRoyalty() public onlyOwner {
        _deleteDefaultRoyalty();
        emit DeleteDefaultRoyalty();
    }

    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 newRoyalty) public onlyOwner {
        require(newRoyalty <= MAX_ROYALTY, "Too high royalty");
        _setTokenRoyalty(tokenId, receiver, newRoyalty);
        emit NewTokenRoyalty(tokenId, receiver, newRoyalty);
    }

    function resetTokenRoyalty(uint256 tokenId) public onlyOwner {
        _resetTokenRoyalty(tokenId);
        emit ResetTokenRoyalty(tokenId);
    }

    function updateWhiteList(address[] memory _whiteListUsers) external onlyOwner {
        require(_whiteListUsers.length > 0, "Invalid Param");
        for(uint i=0; i<_whiteListUsers.length; i++) {
            require(_whiteListUsers[i] != address(0), "Invalid Address");
            unchecked {
                whiteList[_whiteListUsers[i]] = true;
            }
        }
    }
     
    function removeWhiteList(address[] memory _whiteListUsers) external onlyOwner {
        require(_whiteListUsers.length > 0, "Invalid Param");
        for(uint i=0; i<_whiteListUsers.length; i++) {
            require(_whiteListUsers[i] != address(0), "Invalid Address");
            unchecked {
                whiteList[_whiteListUsers[i]] = false;
            }
        }
    }
    
    function updateGoLiveDate(uint256 _newLiveDate) external onlyOwner {
        goLiveDate = _newLiveDate;
        emit UpdateGoLiveDate(_newLiveDate);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        if(to == address(this) || (block.timestamp < goLiveDate && !whiteList[to])) {
            revert NotWhiteList();
        }
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ONFT721) returns (bool) {
        return interfaceId == type(IHopliteNFT).interfaceId || super.supportsInterface(interfaceId);
    }
}