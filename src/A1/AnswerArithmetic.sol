// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AnswerArithmetic {
    /**
        A-1. 四則演算を試す/gasleft()とconsole.log()を学ぶ
    */
    //何も読まない、ステートも変更しない場合、ファンクションで pure を宣言できます。
    function calc() external pure returns (uint256) {
    return ~uint256(0); // Note: 2^256 - 1を返す
    //~(チルダ):ビット反転 ex 001⇨100
  }
}
