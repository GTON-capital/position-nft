// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import '@openzeppelin/contracts/utils/Strings.sol';
import 'base64-sol/base64.sol';
import './HexStrings.sol';
import './SVGSupplier.sol';

library NFTDescriptor {
    // using Strings for uint256;
    using HexStrings for uint256;

    struct URIParams {
        uint256 tokenId;
        uint256 bondingPeriodInDays;
        uint256 bondAmount;
        string tokenSymbol;
    }

    function constructTokenURI(URIParams memory params) public pure returns (string memory) {
        string memory name = string(abi.encodePacked(params.tokenSymbol, '-NFT'));
        string memory description = generateDescription();
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

    function escapeQuotes(string memory symbol) internal pure returns (string memory) {
        bytes memory symbolBytes = bytes(symbol);
        uint8 quotesCount = 0;
        for (uint8 i = 0; i < symbolBytes.length; i++) {
            if (symbolBytes[i] == '"') {
                quotesCount++;
            }
        }
        if (quotesCount > 0) {
            bytes memory escapedBytes = new bytes(symbolBytes.length + (quotesCount));
            uint256 index;
            for (uint8 i = 0; i < symbolBytes.length; i++) {
                if (symbolBytes[i] == '"') {
                    escapedBytes[index++] = '\\';
                }
                escapedBytes[index++] = symbolBytes[i];
            }
            return string(escapedBytes);
        }
        return symbol;
    }

    function addressToString(address addr) internal pure returns (string memory) {
        return (uint256(uint160(addr))).toHexString(20);
    }

    function toColorHex(uint256 base, uint256 offset) internal pure returns (string memory str) {
        return string((base >> offset).toHexStringNoPrefix(3));
    }

    function generateDescription() private pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    'This NFT represents a position in GTON token boinding ',
                    'The owner of this NFT can claim sGTON after bond expiration.\\n'
                )
            );
    }

    function generateSVGImage(URIParams memory params) internal pure returns (string memory svg) {
        SVGSupplier.SVGParams memory svgParams =
            SVGSupplier.SVGParams({
                tokenId: params.tokenId,
                bondingPeriodInDays: params.bondingPeriodInDays,
                bondAmount: params.bondAmount,
                tokenSymbol: params.tokenSymbol,
                color0: toColorHex(uint256(keccak256(abi.encodePacked(address(0), params.tokenId))), 136),
                color1: toColorHex(uint256(keccak256(abi.encodePacked(address(0), params.tokenId))), 0)
            });

        return SVGSupplier.generateSVG(svgParams);
    }
}
