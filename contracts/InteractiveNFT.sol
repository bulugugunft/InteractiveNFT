// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InteractiveNFT is ERC721, Ownable {

    string private script;
    uint256 private mintIndex = 0;

    mapping(uint256 => string) public bgColorMap;
    mapping(uint256 => string) public textMap;

    constructor() ERC721("InteractiveNFT", "InteractiveNFT")  {}

    function mint() public {
        _safeMint(msg.sender, mintIndex);
        bgColorMap[mintIndex] = "black";
        textMap[mintIndex] = "ok";
        mintIndex++;
    }

    function setText(uint256 tokenId, string memory text) public {
        require(msg.sender == ownerOf(tokenId), "only nft owner can change");
        textMap[tokenId] = text;
    }

    function setBgColor(uint256 tokenId, string memory color) public {
        require(msg.sender == ownerOf(tokenId), "only nft owner can change");
        bgColorMap[tokenId] = color;  
    }
    
    function setScript(string memory s) public onlyOwner {
        script = s;
    }


    function getScript() internal view returns (string memory) {
        return script;
    }


    function tokenURI(uint256 tokenId) override public view  returns (string memory) {
        string[9] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="';
        parts[1] = bgColorMap[tokenId];
        parts[2] = '"/><text x="10" y="20" class="base" id="changecolor">';
        parts[3] = "change background color ";
        parts[4] = '</text><text x="10" y="40" class="base" id="changetext">';
        parts[5] = "change text ";
        parts[6] = '</text><text x="10" y="60" class="base" id="showtext">';
        parts[7] = textMap[tokenId];
        parts[8] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', toString(tokenId), '", "description": "interactive NFT", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '","script": "', getScript(), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }


    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

}

library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}