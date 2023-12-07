// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RandomBalls is ERC721 {
    using Strings for uint256;

    string[] private colors = ["#FF5733", "#33FF57", "#3357FF", "#FF33F5", "#33FFF5", "#F5FF33", "#F5F5F5"];
    uint256 private maxBalls = 5;

    constructor() ERC721("RandomBallsNFT", "RBALL") {}

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory svg = generateSVG(tokenId);
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));
    }

    function generateSVG(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(tokenId)));
        uint256 numBalls = (rand % maxBalls) + 1;
        string memory svgString = "<svg xmlns='http://www.w3.org/2000/svg' width='500' height='500'><rect width='100%' height='100%' fill='white' />";
        
        for (uint256 i = 0; i < numBalls; i++) {
            string memory color = colors[(rand >> i) % colors.length];
            uint256 cx = (rand >> (i + 1)) % 500;
            uint256 cy = (rand >> (i + 2)) % 500;
            uint256 r = ((rand >> (i + 3)) % 30) + 10; // Radius between 10 and 40
            svgString = string(abi.encodePacked(svgString, "<circle cx='", cx.toString(), "' cy='", cy.toString(), "' r='", r.toString(), "' fill='", color, "' />"));
        }

        svgString = string(abi.encodePacked(svgString, "</svg>"));
        return svgString;
    }
}


// Base64 Encoding
library Base64 {
    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some space for the null byte
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // output ptr
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
                dataPtr := add(dataPtr, 3)

                // read 3 bytes
                let input := mload(dataPtr)

                // write 4 characters
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
                resultPtr := add(resultPtr, 1)
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
                resultPtr := add(resultPtr, 1)
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
                resultPtr := add(resultPtr, 1)
                mstore(resultPtr, shl(248, mload(add(tablePtr, and(input, 0x3F)))))
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }

        return result;
    }
}