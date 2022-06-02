// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

import './NFT.sol';
import './libraries/NFTDescriptor.sol';
import './interfaces/IBokkyPooBahsDateTimeLibrary.sol';
import './libraries/HexStrings.sol';
import './interfaces/IBondStorage.sol';
import './interfaces/AdminAccess.sol';

contract GTONBondNFT is NFT, IBondStorage, AdminAccess {

    using SafeERC20 for IERC20;
    using Strings for uint256;

    address bokkyPooBahsAddress;

    constructor(
        string memory name_, 
        string memory symbol_,
        string memory bondTokenSymbol_,
        address bokkyPooBahsAddress_
    ) NFT(name_, symbol_) {
        bondTokenSymbol = bondTokenSymbol_;
        bokkyPooBahsAddress = bokkyPooBahsAddress_;
    }

    /* ========== STATE VARIABLES ========== */
    mapping(address => uint[]) public userIds;
    mapping(uint => address) public issuedBy;
    mapping(uint => string) public releaseDates;
    mapping(uint => uint) public rewards;
    string public bondTokenSymbol;

    function userIdsLength(address user) public view returns(uint) {
        return userIds[user].length;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */
    function mint(address to, uint releaseTimestamp, uint reward) public onlyAdminOrOwner returns(uint tokenId) {
        tokenId = _safeMint(to, '');
        userIds[to].push(tokenId);
        issuedBy[tokenId] = msg.sender;
        (uint year, uint month, uint day) = IBokkyPooBahsDateTimeLibrary(bokkyPooBahsAddress).timestampToDate(releaseTimestamp);
        releaseDates[tokenId] = string(
            abi.encodePacked(
                day.toString(),
                '/',
                month.toString(),
                '/',
                year.toString()
            )
        );
        rewards[tokenId] = reward;
    }

    function transfer(address to, uint tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "BondStorage: You are not the owner");
        _transfer(msg.sender, to, tokenId);
    }

    function _tokenURI(uint256 tokenId) internal view virtual override returns (string memory) {
        return
            NFTDescriptor.constructTokenURI(
                NFTDescriptor.URIParams({
                    tokenId: tokenId,
                    releaseDate: releaseDates[tokenId],
                    reward: rewards[tokenId],
                    tokenSymbol: bondTokenSymbol
                })
            );
    }
}
