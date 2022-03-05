// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

import './NFT.sol';
import './libraries/NFTDescriptor.sol';
import './interfaces/IBondStorage.sol';
import './interfaces/AdminAccess.sol';

contract GTONBondNFT is NFT, IBondStorage, AdminAccess {

    using SafeERC20 for IERC20;

    constructor(string memory _name, string memory _symbol) NFT(_name, _symbol) {
    }

    /* ========== STATE VARIABLES ========== */
    uint public tokenCounter = 0;
    mapping(address => uint[]) public userIds;
    mapping(uint => address) public issuedBy;
    mapping(uint => uint) public bondPeriod;
    mapping(uint => uint) public bondValue;

    function userIdsLength(address user) public view returns(uint) {
        return userIds[user].length;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */
    function mint(address to, uint period, uint value) public onlyAdminOrOwner returns(uint tokenId) {
        tokenId = tokenCounter;
        _safeMint(to, tokenCounter);
        userIds[to].push(tokenId);
        issuedBy[tokenId] = msg.sender;
        bondPeriod[tokenId] = period;
        bondValue[tokenId] = value;
        // it always increases and we will never mint the same id
        tokenCounter++;
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
                    bondingPeriodInDays: bondPeriod[tokenId],
                    bondAmount: bondValue[tokenId],
                    tokenSymbol: "GTON"
                })
            );
    }
}
