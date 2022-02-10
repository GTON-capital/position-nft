// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import '@openzeppelin/contracts/token/ERC721/IERC721.sol';

interface INFTManager is IERC721 {
    function burn(uint256 tokenId) external;

    function mint() external;
}
