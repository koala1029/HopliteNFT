// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@layerzerolabs/solidity-examples/contracts/token/onft721/ONFT721.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IHopliteNFT.sol";


contract HopliteNFT is Ownable, ONFT721, ERC2981, IHopliteNFT {
}