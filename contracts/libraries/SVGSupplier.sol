// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import '@openzeppelin/contracts/utils/Strings.sol';
import 'base64-sol/base64.sol';
import './HexStrings.sol';

library SVGSupplier {
    using Strings for uint256;

    struct SVGParams {
        uint256 tokenId;
        string releaseDate;
        uint256 reward;
        string tokenSymbol;
        string color0;
        string color1;
    }

    function generateSVG(SVGParams memory params) internal pure returns (string memory svg) {
        return
            string(
                abi.encodePacked(
                    generateSVGDefs(params),
                    generateSVGFigures(params),
                    '</svg>'
                )
            );
    }

    function generateSVGDefs(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<defs>',
                '<linearGradient id="g1" x1="0%" y1="50%" >',
                generateSVGColorPartOne(params),
                generateSVGColorPartTwo(params),
                '</linearGradient></defs>'
            )
        );
    }

    function generateSVGColorPartOne(SVGParams memory params) private pure returns (string memory svg) {
        string memory values0 = string(abi.encodePacked('#', params.color0, '; #', params.color1));
        string memory values1 = string(abi.encodePacked('#', params.color1, '; #', params.color0));
        svg = string(
            abi.encodePacked(
                '<stop offset="0%" stop-color="#',
                params.color0,
                '" >',
                '<animate id="a1" attributeName="stop-color" values="',
                values0,
                '" begin="0; a2.end" dur="3s" />',
                '<animate id="a2" attributeName="stop-color" values="',
                values1,
                '" begin="a1.end" dur="3s" /></stop>'
            )
        );
    }

    function generateSVGColorPartTwo(SVGParams memory params) private pure returns (string memory svg) {
        string memory values0 = string(abi.encodePacked('#', params.color0, '; #', params.color1));
        string memory values1 = string(abi.encodePacked('#', params.color1, '; #', params.color0));
        svg = string(
            abi.encodePacked(
                '<stop offset="100%" stop-color="#',
                params.color1,
                '" >',
                '<animate id="a3" attributeName="stop-color" values="',
                values1,
                '" begin="0; a4.end" dur="3s" />',
                '<animate id="a4" attributeName="stop-color" values="',
                values0,
                '" begin="a3.end" dur="3s" /></stop>'
            )
        );
    }

    function generateSVGText(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g fill="black" font-family="Impact" font-size="24"><text x="20" y="40" >',
                params.tokenSymbol,
                ' Bonding NFT',
                '</text><text x="20" y="70">Bond reward, ',
                params.tokenSymbol,
                ': ',
                params.reward.toString(),
                '</text><text x="20" y="100">Claim after: ',
                params.releaseDate,
                '</text><text x="20" y="482">ID: ',
                params.tokenId.toString(),
                '</text></g>'
            )
        );
    }

    function generateSVGFigures(SVGParams memory params) private pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<rect id="r" x="0" y="0" rx="15" ry="15" width="512" height="512" fill="url(#g1)" />',
                generateSVGText(params),
                '<g fill="#00A3FF"></g>',
                '<path d="M256 128.1c0 20.2-4.7 39.3-13.1 56.3 0 .1-.1.1-.1.2-.2.4-.4.8-.4 1-.1.2-.2.3-.3.5-.1.2-.2.3-.3.5-10.2 19.6-24.8 35.6-42 47.2-.1.1-.2.2-.3.2-.2.1-.3.2-.5.3-.4.3-.8.6-1.2.8-.5.3-.9.6-1.4.9-.5.3-.9.6-1.4.9l-.1.1c-19.5 12-42.4 18.9-66.8 18.9-2.4 0-4.7-.1-7.1-.2h-1c-.8 0-1.6-.1-2.4-.2-.2 0-.4 0-.6-.1-.2 0-.5-.1-.7-.1-.7-.1-1.3-.1-2-.2-.5 0-.9-.1-1.4-.1h-.2c-.3 0-.6-.1-.9-.1-.3 0-.6-.1-.9-.1-.3 0-.5-.1-.8-.1-.3 0-.5-.1-.8-.1-.3 0-.6-.1-.9-.1-.3 0-.6-.1-.9-.1-.3 0-.5-.1-.8-.1-.3 0-.5-.1-.8-.1-.3-.1-.6-.1-.9-.2-.3-.1-.7-.1-1-.2-.4-.1-.8-.1-1.2-.2h-.2c-.7-.1-1.5-.3-2.2-.5-.4-.1-.8-.1-1.1-.2-1.1-.3-2.2-.5-3.3-.8-.1 0-.2 0-.3-.1-.1 0-.1 0-.2-.1-.9-.3-1.9-.5-2.8-.8-.4-.1-.7-.2-1-.3-.4-.1-.8-.2-1.1-.3-.4-.1-.8-.2-1.1-.3l-.9-.3c-.1 0-.2-.1-.2-.1-.7-.2-1.4-.5-2.2-.7-.2-.1-.4-.1-.6-.2s-.4-.1-.6-.2c-.3-.1-.7-.3-1-.4-.4-.1-.7-.3-1-.4-.2-.1-.3-.1-.5-.2s-.5-.2-.7-.3c-.7-.3-1.4-.5-2.1-.8-.2-.1-.4-.2-.6-.2-.2-.1-.4-.2-.6-.2-.3-.1-.6-.3-.9-.4-.3-.1-.6-.3-.9-.4-1.2-.5-2.4-1-3.5-1.6-.1 0-.1-.1-.2-.1s-.1-.1-.2-.1c-.3-.1-.6-.3-.8-.4-.3-.1-.6-.3-.9-.5-1.2-.6-2.5-1.3-3.8-2-.9-.5-1.7-1-2.6-1.4-.1-.1-.2-.1-.3-.2l-.1-.1c-22.2-12.8-39.8-31.6-51-54.5-.1-.2-.2-.5-.3-.7-.1-.2-.2-.5-.3-.7-.4-.8-.7-1.5-1.1-2.3-.7-1.5-1.4-3.1-2-4.7 0-.1-.1-.2-.1-.3 0-.1-.1-.2-.1-.3-2.3-5.7-4.2-11.7-5.6-17.9v-.2c-.4-1.7-.8-3.4-1.1-5.1-.1-.3-.1-.7-.2-1-.1-.3-.1-.7-.2-1-.2-1.1-.4-2.2-.5-3.2-2.4-15.8-1.7-31.8 1.9-47.4 0-.2.1-.3.1-.5s.1-.3.1-.5c.4-1.5.7-3 1.1-4.5.3-1.2.7-2.5 1.1-3.7l.6-1.8c.5-1.5 1-3 1.6-4.5.1-.2.1-.4.2-.5.1-.2.1-.4.2-.5.6-1.6 1.2-3.2 1.9-4.9.1-.2.1-.3.2-.5s.1-.3.2-.5c.7-1.6 1.4-3.1 2.1-4.7 0-.1.1-.2.1-.3 0-.1.1-.2.1-.3.1-.3.3-.6.5-.9.6-1.3 1.3-2.5 2-3.8.2-.4.5-.9.7-1.3.2-.4.5-.9.7-1.3 0-.1.1-.2.2-.3l.1-.1C30 41.8 48.8 24.2 71.7 13.1c.5-.3 1-.5 1.5-.7.4-.2.8-.3 1.1-.5.4-.2.8-.4 1.1-.5 1.5-.7 3.1-1.4 4.7-2 .1 0 .2-.1.3-.1.1 0 .2-.1.3-.1C86.5 6.9 92.5 5 98.6 3.6h.2c1.7-.4 3.4-.8 5.2-1.1.3-.1.7-.1 1-.2.3-.1.6-.1.9-.2.6-.1 1.1-.2 1.7-.3s1.1-.2 1.7-.3c25.5-3.8 51.4.1 75 11.7l-19.7 40.2c-11.6-5.7-24.1-8.5-36.6-8.5-4.2 0-8.3.3-12.3.9-.2 0-.3.1-.5.1s-.3.1-.5.1c-.9.1-1.9.3-2.8.5-.3.1-.6.1-.9.2-.3.1-.6.1-.9.2-.3.1-.6.2-1 .2-.3.1-.6.1-1 .2-.1 0-.3.1-.4.1-.7.2-1.3.3-2 .5-.2.1-.5.1-.7.2-.2.1-.5.1-.7.2-.9.3-1.8.5-2.6.8-.2.1-.5.2-.7.2-.2.1-.4.1-.7.2-.8.3-1.5.6-2.3.9-.1 0-.3.1-.4.2-.5.2-1 .4-1.4.6-.4.2-.8.3-1.2.5-.1.1-.2.1-.4.2-.9.4-1.8.8-2.6 1.2-.1 0-.2.1-.2.1-.1 0-.2.1-.2.1C76 60.9 63 73.3 54.7 88.5v.2c-.6 1.1-1.1 2.2-1.7 3.3l-.3.6-.3.6c-.4.8-.8 1.6-1.1 2.5-.1.2-.2.5-.3.7-.1.2-.2.5-.3.7-.1.3-.2.5-.3.8-.2.5-.5 1.1-.6 1.6 0 .1-.1.3-.1.4 0 .1-.1.3-.1.4-3.1 8.7-4.8 18.1-4.8 27.8 0 4.2.3 8.3.9 12.4 0 .1 0 .3.1.4 0 .1 0 .3.1.4.2 1 .3 2 .5 2.9.1.6.2 1.1.4 1.7.1.6.2 1.1.4 1.7 0 .1.1.2.1.3.1.5.3 1.1.4 1.6.1.2.1.5.2.7.1.3.2.6.2.9.1.2.1.4.2.6.1.5.3 1.1.5 1.6l.3.9c.2.5.3 1 .5 1.4.3.8.5 1.5.8 2.2.1.3.3.6.4.9.1.3.2.6.4.9.1.2.2.5.3.7.1.2.2.5.3.7l1.2 2.7c.1.1.2.3.2.4 7.6 15.7 20 28.6 35.3 36.9 1.1.6 2.3 1.2 3.4 1.8.3.2.7.3 1 .5.2.1.3.1.5.2.8.4 1.5.7 2.2 1 .6.3 1.2.5 1.8.7.2.1.3.1.5.2l1.5.6c1.1.4 2.1.8 3.1 1.1.2.1.5.2.8.3 1.2.4 2.5.8 3.8 1.1h.2c1.1.3 2.2.5 3.3.8.2 0 .4.1.6.1h.1c.3.1.7.1 1 .2.3.1.7.1 1 .2.3 0 .7.1 1 .2.3.1.7.1 1 .2.6.1 1.2.2 1.8.2.3 0 .5.1.8.1.5.1 1 .1 1.5.2.4 0 .7.1 1.1.1.3 0 .7 0 1 .1.6.1 1.3.1 1.9.2.6 0 1.2.1 1.8.1h2.3c1.2 0 2.4 0 3.5-.1h.4c12-.5 23.8-3.6 34.5-9.1h.2c1-.5 2-1 3-1.6l1-.6c.7-.4 1.4-.8 2-1.2l.9-.6.9-.6c.2-.1.4-.2.5-.4.2-.1.4-.2.5-.4.9-.6 1.8-1.2 2.7-1.9l.1-.1s.1 0 .1-.1c9.5-7.1 17.5-16.3 23.3-26.9 0-.1.1-.2.2-.3.1-.1.1-.2.2-.3 6.3-11.7 9.8-25 9.8-39.1H256zm-44.8-45.7h-45.7v45.7h45.7V82.4z" style="fill-rule:evenodd;clip-rule:evenodd;fill:#020203" transform="matrix(1.00154 0 0 1.00076 127.605 127.906)"/>'
            )
        );
    }
}
