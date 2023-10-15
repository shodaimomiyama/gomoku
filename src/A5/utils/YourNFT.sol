// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YourNFT is ERC721, Ownable {
    using Counters for Counters.Counter; //ライブラリは指定したデータ型に対して、ライブラリで定義したメソッドを追加することができます。
    Counters.Counter private _tokenIds;

    constructor() ERC721("YourNFT", "YNFT") {} //constructorをちゃんと学ぶ！
    //名前とシンボル

    function mintItem(address to)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 id = _tokenIds.current();
        _mint(to, id);

        return id;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://ikzttp.mypinata.cloud/ipfs/QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/";
    }
}
