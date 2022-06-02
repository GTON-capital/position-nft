//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IBokkyPooBahsDateTimeLibrary {

    /**
     * @dev Mints new token for message sender.
     * 
     * Accessible by owner only!
     */
    function timestampToDate(uint timestamp) external returns (uint year, uint month, uint day);
}
