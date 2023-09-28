// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {AnswerStructAndStorage} from "src/A2/AnswerStructAndStorage.sol";
import {SAnswerStructAndStorage} from "src/A2/interfaces/SAnswerStructAndStorage.sol";

contract  QuestionStructAndStorage is Test, SAnswerStructAndStorage {
    using stdStorage for StdStorage;

    //ジェネリクスとは、「総称性（Genericity）」「ジェネリック・プログラミング」とも呼ばれるプログラミング技法で、 オブジェクト指向とは異なるパラダイムからきたものです。 データの型に束縛されず、型そのものをパラメータ化して扱うことができます。
    //using A for B; という指示はライブラリのファンクション（ A というライブラリから）をどんな型(B)にも加えるのに使うことができます。 このファンクションは最初のパラメータとして（Pythonの self の様に）、そのファンクションを呼び出したオブジェクトを受け取ります。
    //DRY(Don't Repeat Yourself:同じことを繰り返すな)原則は、非常に重要なものです。これは、1つのシステムの中で同じものが重複することがあってはならないという原則です。言い換えれば、1つの知識に対応する実装は必ず1つにする、ということです。
    AnswerStructAndStorage structAndStorage; //型（クラス型）、変数
    //変数とはデータを格納しておく領域のことです。変数は通常メモリ上に確保され、値を代入したり参照したりすることができます。それぞれの領域を区別するために変数名を付けて宣言します。また型とは、数字や文字などのデータをメモリ上に確保する領域やバイト長、確保した領域の扱い方などを指定するものです。



    struct Test2Vars {
      uint256 slot;
    }

    function setUp() public {
        // クラスのインスタンスを作成 == インスタンス化
        // それを変数に代入している, 最初の変数への代入 == 初期化
        structAndStorage = new AnswerStructAndStorage();  
    }

    function test_Q2_StructAndStorage() public {
        Test2Vars memory vars;
        YourScore memory _score;
        _score.name = "John Doe";
        _score.description = "This is a sample score.";
        _score.score = 50;

        structAndStorage.submitScoreWithCheat(_score);

        vars.slot = stdstore
                        .target(address(structAndStorage)) 
                        .sig(structAndStorage.scores.selector)
                        .with_key(address(this))
                        .depth(2) // Note: Struct getter returns array of members
                        .find();
        assertEq(uint256(vm.load(address(structAndStorage), bytes32(vars.slot))), 100);

        //assertEq(param_1, param_2)を利用することで、パラメータ1とパラメータ2が等しいかどうかをチェック
        //コントラクトから引数を持ってくる
        //load⇨structAndStorage(object型)をaddress型に変える、vars.slotをbyte型に変える
        //slot保存領域
        /*
            Hint:
                このテストはストレージに狙った値が入っていることをテストしています。
                したがって、ストレージを検査するために外部からストレージを閲覧できるようにしてあげる必要があります。
                Solidityにおいてことなるコントラクトを叩くときは、インターフェースを用います。
                インターフェースはコンパイラに型情報をよりたくさん与えられるので、
                コンパイラが人間の代わりにミスを発見してくれる良さもあります。
        */
    }
}