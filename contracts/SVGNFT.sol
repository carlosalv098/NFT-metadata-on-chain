// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

contract SVGNFT is ERC721URIStorage {

    uint256 public tokenId;
    constructor() ERC721 ("NFT SVG", "sNFT") {
        tokenId = 0;
    }

    function create (string memory svg) public {
        _safeMint(msg.sender, tokenId);
        // create imageURI
        string memory imageURI = svgToImageURI(svg);
        // create tokenURI

        tokenId ++;
    }

    function svgToImageURI(string memory svg) public pure returns(string memory imageURI) {
        string memory baseURL = 'data:image/svg+xml;base64,';
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        imageURI = string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function formatTokenURI(string memory imageURI) public pure returns(string memory tokenURI) {
        string memory baseURL = 'data:application/json;base64,';
        tokenURI = string(abi.encodePacked(
            baseURL,
            Base64.encode(bytes(abi.encodePacked(
                '{"name": "SVG NFT",'
                '"description": "NFT based on SVG",'
                '"attributes": "",'
                '"image": "', imageURI, '"}'
            ))) 
        ));
    }
}