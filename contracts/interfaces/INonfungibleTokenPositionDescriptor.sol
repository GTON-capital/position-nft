// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Describes position NFT tokens via URI
interface INonfungibleTokenPositionDescriptor {
    /// @notice Produces the URI describing a particular token ID for a position manager
    /// @dev Note this URI may be a data: URI with the JSON contents directly inlined
    /// @param tokenId The ID of the token for which to produce a description, which may not be valid
    /// @return The URI of the ERC721-compliant metadata
    function tokenURI(uint256 tokenId)
        external
        view
        returns (string memory);
}
