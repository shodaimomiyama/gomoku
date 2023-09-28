// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {AnswerArithmetic} from "src/A1/AnswerArithmetic.sol";
//AnswerArithmeticをtestへimport、動かすのはtest側
contract QuestionArithmetic is Test {
    AnswerArithmetic arithmetic; //クラス　インスタンス　ハコを作る

    struct Test1Vars {
        uint256 tempGas;
        uint256 execGas;
        uint256 result;
    }

    function setUp() public {
        arithmetic = new AnswerArithmetic();
    }

    /**
        Q-1. 制御構文(if, for, require, revert), modifier, アクセス制御, オーナー権限を試す
     */
//１行１行ガス代がかかっている
//似たようなオブジェクトを複数作る時に、全てのプロパティやメソッドをいちいちプログラミングするのは非常に手間が掛かりますが、継承を使うことにより、同じ機能を実装できます。
    function test_Q1_Arithmetic() public { //publicは定義されたコントラクトとこのコントラクトを継承したコントラクトから呼び出すことができかつ、外部から呼び出すことができます。
        Test1Vars memory vars; //memoryはブロックチェーンに書き込まないのでコストはかかりません。

        vars.tempGas = gasleft(); //残ガス
        vars.result = arithmetic.calc();//計算したからガス代が減っている
        //console.log(vars.result); // Note: Try me, and remove me later ;)
        vars.execGas = vars.tempGas - gasleft(); //このgasleftは上のgasleftとは違うもの、calcを踏まえたもの
                                                 //vars.tempGasは29行目のgasleftが入っていて、値は変わっていない
        assertTrue(vars.result == 115792089237316195423570985008687907853269984665640564039457584007913129639935);//uint256の最大値（10進数ver）
        assertTrue(vars.execGas < 6000); // Note: ただし上記の値をそのままコピペすることは無効です
    }
}
