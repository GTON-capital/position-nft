// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import '@openzeppelin/contracts/utils/Strings.sol';
import 'base64-sol/base64.sol';
import './HexStrings.sol';
import './SVGSupplier.sol';

library NFTDescriptor {
    // using Strings for uint256;
    using HexStrings for uint256;

    struct URIParams {
        uint256 tokenId;
        string releaseDate;
        uint256 reward;
        string tokenSymbol;
    }

    function constructTokenURI(URIParams memory params) public pure returns (string memory) {
        string memory name = string(abi.encodePacked(params.tokenSymbol, '-NFT'));
        string memory description = generateDescription(params);
        string memory image = Base64.encode(bytes(generateSVGImage(params)));

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '", "description":"',
                                description,
                                '", "image": "',
                                'data:image/svg+xml;base64,',
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function toColorHex(uint256 base, uint256 offset) internal pure returns (string memory str) {
        return string((base >> offset).toHexStringNoPrefix(3));
    }

    function generateDescription(URIParams memory params) private pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    'This NFT represents a position in ',
                    params.tokenSymbol,
                    ' token boinding. ',
                    'The owner of this NFT can claim tokens after bond expiration.\\n'
                )
            );
    }

    function generateSVGImage(URIParams memory params) internal pure returns (string memory svg) {
        SVGSupplier.SVGParams memory svgParams =
            SVGSupplier.SVGParams({
                tokenId: params.tokenId,
                releaseDate: params.releaseDate,
                reward: params.reward,
                tokenSymbol: params.tokenSymbol,
                color0: toColorHex(uint256(keccak256(abi.encodePacked(address(0), params.tokenId))), 136),
                color1: toColorHex(uint256(keccak256(abi.encodePacked(address(0), params.tokenId))), 0)
            });

        return SVGSupplier.generateSVG(svgParams);
    }
}
