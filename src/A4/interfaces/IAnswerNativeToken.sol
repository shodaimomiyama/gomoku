// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SAnswerNativeToken } from "src/A4/interfaces/SAnswerNativeToken.sol";

interface IAnswerNativeToken {
    function gimmeLicense(SAnswerNativeToken.LicenseCandidate memory candidate) external payable;
    // payable修飾子を付けることでetherを受け取れるようになる
    function licenseHolders(address _key) external returns (address, uint256);
    //functionだが中身なし→インターフェースだから
}
