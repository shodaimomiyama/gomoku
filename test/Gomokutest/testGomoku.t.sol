//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../../lib/forge-std/src/Test.sol";
import { ItestGomoku } from "./interface/ItestGomoku.sol";
import { GomokuV1 } from "../../Gomoku/GomokuV1.sol";
import { GameV1 } from "../../Gomoku/GameV1.sol";
import { IAnswerGomoku } from "../../Gomoku/IAnswerGomoku.sol";
import { SAnswerGomoku } from "../../Gomoku/SAnswerGomoku.sol";


contract testGomoku is Test, ItestGomoku, SAnswerGomoku {

    GomokuV1 gomoku;
    GameV1 game;

    function setUp() public {
        gomoku = new GomokuV1(); //contract //コントラクトインスタンスに関して、実際にはそれ自体が変数のデータとして存在するわけではありません。代わりに、コントラクトインスタンス変数はブロックチェーン上の特定のアドレスを指し示しています。このアドレスは、新しくデプロイされたコントラクトの場所を示しています。したがって、storageやmemoryキーワードの使用が不適切なのです。要するに、コントラクトインスタンスは実際のデータを持つわけではなく、単にブロックチェーン上のある場所（アドレス）を指す参照として機能するため、storageやmemoryといったデータロケーションの指定が不要なのです。
        game = new GameV1(); //contract
        game.setUp(gomoku);
    }

    function testOpenGame() public {

    /*1.asomokunation*/
        TestUsers memory testusers;
        testusers.alice.addr = makeAddr("Alice");

    /*2.execution*/
        vm.prank(testusers.alice.addr);
        uint256 gid = gomoku.openGame(testusers.alice); //新しいgidを生成
        address player1 = game.getPlayer1(gid);
        uint256 gamelen = gomoku.getGameLen();

    /*3.assertion*/
        assert(gamelen == 1);
        assert(player1 == testusers.alice.addr);

    }

    function testJoinGame() public {

        /*1.asomokunation*/
        TestUsers memory testusers;
        testusers.alice.addr = makeAddr("Alice");
        testusers.bob.addr = makeAddr("Bob");

        /*2.execution*/
        //vm.prank(testusers.bob.addr);
        vm.prank(testusers.alice.addr);
        gomoku.openGame(testusers.alice);
        uint[] memory lsgames_array = gomoku.listGame(); //return uint[] _gid;
        vm.prank(testusers.bob.addr);
        uint256 gid = gomoku.joinGame(testusers.bob); //bobが_gidをゲット
        address player2 = game.getPlayer2(gid); //player2にbobがエントリー Bobの_gidとAliceの_gidが同じだったら

        /*3.assertion*/
        assert(player2 == testusers.bob.addr);

    }

    function testStartGame() public {

        /*1.asomokunation*/
        TestUsers memory testusers;
        GameSetting memory gamesetting;
        testusers.alice.addr = makeAddr("Alice");
        testusers.bob.addr = makeAddr("Bob");

        uint256 gid;
        uint8 grid_x;
        uint8 grid_y;

        vm.prank(testusers.alice.addr);
        gid = gomoku.openGame(testusers.alice); //新しいgidを生成
        address player1 = game.getPlayer1(gid);
        uint[] memory lsgames_array = gomoku.listGame(); //return uint[] _gid;

        vm.prank(testusers.bob.addr);
        gid = gomoku.joinGame(testusers.bob); //bobが_gidをゲット
        address player2 = game.getPlayer2(gid); //player2にbobがエントリー Bobの_gidとAliceの_gidが同じだったら


        /*2.execution*/
        gamesetting.canStart = game.startGame(player1);
        /*3.assertion*/
        assertTrue(gamesetting.canStart);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player1, 2, 2, GameV1.Player._player1); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);
        //Solidityの構文において、uint型のリテラルを指定する場合、uintキーワードを使用する必要はありません。
        /*
        game は GameV1 インスタンスを指しており、具体的なインスタンス（オブジェクト）に対する操作として扱われます。
        一方で、enum のようなデータ型やその中の値は、特定のインスタンスに属しているわけではなく、
        むしろコントラクト自体（つまり、クラスのようなもの）に属しています。
        Solidity では、コントラクト自体に属するデータ型やその中の値にアクセスするためには、コントラクト名を使用して参照する必要があります。
        そのため、GameV1.Player._player1 という形式で参照するのが正しいのです。
        */


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player2, 6, 2, GameV1.Player._player2); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player1, 3, 3, GameV1.Player._player1); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player2, 6, 3, GameV1.Player._player2); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player1, 4, 4, GameV1.Player._player1); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player2, 6, 4, GameV1.Player._player2); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player1, 5, 5, GameV1.Player._player1); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player2, 6, 5, GameV1.Player._player2); //石を置いたところには置けない設定を作る(require)
        gamesetting.canContinue = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertFalse(gamesetting.canContinue);


        /*2.execution*/
        (grid_x, grid_y) = game.addstone(player1, 6, 6, GameV1.Player._player1); //石を置いたところには置けない設定を作る(require)
        gamesetting.canEnd = game.judge(grid_x, grid_y);
        /*3.assertion*/
        assertTrue(gamesetting.canEnd);


    }

}





/**
contract gmkUsers is Test, IAnswerGomoku {
    GomokuV1 gmkContract;

    function setUp() public {
        gmkContract = new GomokuV1();

    }

    function testopengame() public {
        Game memory game; //Game struct型の変数gameをmemoryに入れる

        Gomoku gmk = new Gomoku(); //Gomoku contruct型の変数gmk

        game.A.addr = makeAddr("A"); //addressの送り主とaddressはあってる？
        game.gameID = gmk.makeid(address(game.A.addr)); //gameIDをゲット

        game.B.addr = makeAddr("B");
        gmidB = gmk.listgame(address(game.B.addr)); //gameIDをゲット
        gmk.joingame(address(game.B.addr)); //AとBのgameIDが同じであることが示された。

    }

    function teststartgame() public {
        Game memory game;

        GMKGame gmkgame = new GMKGame(); //GMKGame contruct型の変数gmkgame

        //gridが初めどのマスも何も入っていないことを確かめる uint[0][0]=assertEq[0][0]

        vm.prank(game.A.addr);
        game.grid.putstone();
    }
}
*/


