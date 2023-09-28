// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { SAnswerNFT } from "src/A5/interfaces/SAnswerNFT.sol";
import { IAnswerNFT } from "src/A5/interfaces/IAnswerNFT.sol";

contract AnswerNFT is IAnswerNFT, Ownable {
    /**
        Q-5. ERC-721とapprovalとプログラマブルな送金と多様なコントラクト
        ガチャを通して、ERC-721の内容とコントラクトへの送金を学ぶ
     */
    IERC721 nft;

    /**
     * @dev NFTAddressを設定する関数
     */
    function setNFT(address _nft) public onlyOwner {
        nft = IERC721(_nft);
        //_nftはnftと同じ
    }

    uint256 _boosterCounter = 1;

    /**
     * @dev NFTのガチャガチャを回す関数
     */
    function buyBoosterPack() public payable override {
        // 送信された金額が1 etherであることを確認
        require(msg.value == 1 ether, "You need to pay 1 ether to buy a booster pack.");
        // `_boosterCounter`から始めて5つのNFTトークンを呼び出し元に転送
        for (uint256 i = 0; i < 5; i++) {
            require(nft.ownerOf(_boosterCounter) == address(this), "The NFT is not owned by this contract.");
            nft.transferFrom(address(this), msg.sender, _boosterCounter);
            _boosterCounter++; //++:今の数字に1を足すよ
        }

        // Note: Fill me
    }

    /**
     * @dev 最初にNFTのガチャガチャを回した者に入場の権利を付与する関数
     */
    function canEnterByOriginHolder() public override view returns (bool) {
        // 1番目のNFTの現在の所有者が呼び出し元であるかどうかを確認
        require (nft.ownerOf(1) == msg.sender, "You don't have the first NFT.");
        return true;
        // Note: Fill me
        //ownerOf(1)とかあり？？
    }
}