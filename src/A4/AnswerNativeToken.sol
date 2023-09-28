// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAnswerNativeToken } from "src/A4/interfaces/IAnswerNativeToken.sol";
import { SAnswerNativeToken } from "src/A4/interfaces/SAnswerNativeToken.sol";

contract AnswerNativeToken is IAnswerNativeToken, SAnswerNativeToken {

    /**
        A-4. ネイティブトークン支払いを試す
     */
    // public で mapping を定義すると、 getter も自動で生成される
    mapping(address => LicenseCandidate) public licenseHolders;

    // 保存するための mapping
    // mapping(address => LicenseCandidate) private _licenseHolders;
    // 値を取得するための関数 == getter
    // function licenseHolders(address _key) external view returns (address, uint256) {
    //     return (_licenseHolders[_key].address, _licenseHolders[_key].score);
    // }
    //publicによりlicenseHoldersがview関数の効果を内蔵→コンパイラが文句を言わない
    //このcontract内でlicensHoldersに所定の働きを持たせるには自分で持たせる(mapping的な)

    function gimmeLicense(LicenseCandidate memory candidate)
        external payable override onlyYou2(candidate)
    {
        //合格点数が80点以上、または支払いが0.1ETH以上の場合のみ許可
        // Note: Fix me!
        require(candidate.score >= 90 || msg.value > 0.1 ether, "You failed.");
        //|| msg.value >= 1 ether
        // 候補者をライセンス保持者としてマッピングに保存する
        licenseHolders[msg.sender] = candidate;
        //requireがpassしたら、licenseHoldersとしてmsg.senderのaddressのcandidate[address(addr),uint256(score)]が登録される
    }

    modifier onlyYou2(LicenseCandidate memory candidate) {
        require(msg.sender == candidate.addr, "You are not the owner of this account.");
        _;
    }
}
