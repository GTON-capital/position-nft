// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

abstract contract NFT is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }

    function _safeMint(address to, bytes memory data) internal virtual {
        uint256 currentId = _tokenIdTracker.current();
        super._safeMint(to, currentId, data);
        _tokenIdTracker.increment();
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), 'NFT: URI query for nonexistent token');
        return _tokenURI(tokenId);
    }

    function _tokenURI(uint256 tokenId) internal view virtual returns (string memory);
}
