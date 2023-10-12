//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SAnswerGomoku } from "./SAnswerGomoku.sol";
import { IAnswerGomoku } from "./IAnswerGomoku.sol";
import { GomokuV1 } from "./GomokuV1.sol";

//親クラスから子クラスへの継承は、子クラスが親クラスの機能や変数を継承するという意味での"一方通行"です。逆に、親クラスが子クラスの特定の機能や変数を直接使用することはできません。しかし、子クラスは親クラスの機能や変数にアクセスできます。
//もしGameV1はGomokuV1を継承すると、同時にGomokuV1のインスタンスも持つことになる。これは混乱の原因となります。継承を使っているのであれば、新しいインスタンスを作成するのではなく、GameV1自体がGomokuV1の機能を持っていると考える方が自然です。解決策として、不要な継承やインスタンスの作成を避けるようにコードを整理することをおすすめします。
contract GameV1 is SAnswerGomoku {

    GomokuV1 public gomoku;

    enum GameState { Open, Close }
    GameState public state;

    uint[15][15] public grid;
    enum Player { None, _player1, _player2 } //誰がそのマスにおいたかのおいたかの設定

    constructor() {
        state = GameState.Close;

        for(uint i = 0; i < 15; i++) {
            for(uint j = 0; j < 15; j++) {
                grid[i][j] = 0;
            }
        }

    }

    function setUp(GomokuV1 _gomokuInstance) public {
        gomoku = _gomokuInstance;
    }

    function getPlayer1(uint256 _gid) public returns(address) { 
        //return(_gomoku.games[_gid]); returns(address)だが、Users(struct)を返しているのでエラー
        (address addr, , ,) = gomoku.games(_gid);
        return  addr;
    }

    function getPlayer2(uint256 _gid) public returns(address) {
        
        (address addr, , ,) = gomoku.lastArgument(); //Solidityにおいては、publicで宣言されたステート変数のために、コンパイラは自動的にgetter関数を生成します。そのgetter関数の名前は宣言したステート変数そのものの名前です。
        return  addr; //_gidを受け取った時点でfn joingameの引数の人のaddressを返してあげればいい
    }

    function startGame(address _addr) public returns(bool) { //継承した構造体の一部だけを引数にしたいときは、(address _addr)のようにすれば良い。
        state = GameState.Open;
        //openになったらgridの初期状態をセット→定義しておいた状態変数に代入→順番ごとに更新
        return state == GameState.Open;
    }

    function addstone(address _addr, uint8 x, uint8 y, Player _player) public returns(uint8, uint8) {
        require(state == GameState.Open, "This game is done.");
        require(msg.sender == _addr, "Your turn is not now.");
        require(grid[x][y] == uint8(Player.None), "This place is already put a stone by the other person.");
        grid[x][y] = uint8(_player);

        //return x,y
        return (x, y);
    }

    function consecutive(uint8 x, uint8 y, int8 dx, int8 dy, Player _player) internal view returns(bool) {
        //fn judgeのためのヘルパー関数
        for (uint8 i = 0; i < 5; i++) {
            if (x < 0 || x >= 15 || y < 0 || y >= 15) {
                return false;
            }
            if (Player(grid[x][y]) != _player) { //指定された座標のマスに、指定されたプレイヤーの石が置かれているかを確認しています。
                return false;
            }
            x += uint8(int8(x) + dx);
            y += uint8(int8(y) + dy);
        }
        return true;
    }

    function judge(uint8 x, uint8 y) public returns(bool) {
        Player player = Player(grid[x][y]);
        if (player == Player.None) {
            return false;
        }
        // 8つの方向を確認:  上, 下, 左, 右, 右上, 左下, 左上, 右下
        int8[8] memory dx = [int8(0), int8(0), int8(-1), int8(1), int8(1), int8(-1), int8(-1), int8(1)];
        int8[8] memory dy = [int8(1), int8(-1), int8(0), int8(0), int8(1), int8(-1), int8(1), int8(-1)];

        for (uint8 i = 0; i < 8; i += 2) {
            bool firstDirection = consecutive(x, y, dx[i], dy[i], player);
            bool oppositeDirection = consecutive(x, y, dx[i+1], dy[i+1], player);

            if (firstDirection && oppositeDirection) { //TrueかつTrueなら５個並んでいるということ
                state = GameState.Close;
                return true;
            }
        }
        return false;
    }

}


/*
GameV1コントラクトのsetUp関数でGomokuV1の新しいインスタンスを作成しています。
しかし、テストコード内でGomokuV1の別のインスタンスも作成しているため、これらの2つのインスタンスは異なる状態を持ちます。
具体的には、テストコードでgomoku.openGame(testusers.alice);を実行すると、テスト内で作成されたGomokuV1インスタンスにゲームが追加されます。
一方、GameV1のgetPlayer関数を実行すると、GameV1が保持している別のGomokuV1インスタンスからゲームの情報を取得しようとします。
このため、テストは失敗していると考えられます。
*/