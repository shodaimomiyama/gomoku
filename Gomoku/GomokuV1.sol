// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SGomoku } from "./SGomoku.sol";
import { IGomoku } from "./IGomoku.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract GomokuV1 is SGomoku {

    //event LogAddresses(address indexed sender, address indexed userAddr);

    uint256 public _gid = 0; //まず基準のgidを定義==0
    mapping(uint256 _gid => Users) public _games; //keyが_gidでvalueがUsers(struct)
    //uint[] lsgames_array; //結局mappingにしてbobの_gidとaddressを結びつけた方がいい？
    Users public lastArgument; //変数の型がstructの場合は作った構造体の名前を宣言すれば良い

    function openGame(Users memory user) public returns(uint256) {

        require(msg.sender == user.addr, "Your address is wrong."); //現在の関数を呼び出しているアドレスと引数のaddressが同じであることが前提
        _gid++; //ゲームIDをインクリメント

        //lsgames_array.push(_gid); //_gidリスト（配列）に新しくできた_gidを追加
        /*
        gidは単なるインクリメントした数値なのだから、1から最新のgidまでの数字一つ一つがgame listになる。
        だからわざわざ保存する必要がない(NFTのtokenIdと同じ作り)
        by 落合先生
        */

        Users memory newGame; //Users struct型を持つ新しい変数newGame　これはゲーム用の変数として使うことにする
        newGame.addr = msg.sender;  //現在の関数を呼び出しているアドレスをUsers(struct型)の変数newGameのaddressに代入(msg.senderからUsersstructのaddressを作っちゃっている)
        _games[_gid] = newGame; //keyの_gidに対してvalueのUsersがmsg.senderのaddressが入った状態で更新される。そして_gamesmappingに保存される。
             
        return _gid; //新しいgid(インクリメントされたgid)を返す

    }


    function games(uint256 _gid) public returns(address, uint256, uint256, uint256) {
        Users memory newGame;
        newGame = _games[_gid];

        return (newGame.addr, newGame.wincount, newGame.losecount, newGame.fightcount);

    }

    function getGameLen() public view returns(uint256) {
        return _gid;
    }

    /*function listGame() public view returns(uint[] memory ) {
        return lsgames_array;
    }
    */

    function joinGame(Users memory user, uint targetGid) public returns(bool) {

        //emit LogAddresses(msg.sender, user.addr);
        //require(lsgames_array.length > 0, "No games available to join");
        require(msg.sender == user.addr, "Your address is wrong.");
        lastArgument = user;
        //uint256 _gid = lsgames_array[lsgames_array.length - 1];

        /*
        fn joinGame(uint targedGId) にしてどのゲームに参加するか指定しないとだめ。
        あとは、msg.sendersを用いてストレージに予め保存したusersを取り出して使えばいい
        */
        
        return true;
    }



}



















/**contract GomokuV1 is ERC721, Ownable {
    using Counters for Counters.Counter; //struct couter{uint256 value;}
    Counters.Counter private _gameIds;

    function makeid(address to)
        public
        onlyOwner
        returns (uint256)
    {
        _gameIds.increment(); //counter._valueが1ずつ増えていくよ

        uint256 id = _gameIds.current(); //currentはcounter.valueを返してくれる

        return id;
    }

    function listgame(address addr) public onlyOwner returns (uint256) {
        //Gomokucontractの中からgameIDをもらえる
        require( id != 0 , " No one play the game. ");
        return id;

    }

    function joingame(address addr) public override view returns (bool) {
        require ( gmidB == id, "Your gameID is different from owner's.");
        //BのgameIDはAと同じでないといけない
        return true;
        
    }

}

contract GMKGame is SAnswerGomoku {

    function putstone(uint256 row, uint256 column) public override view returns(uint[row][column]) {

    }
}
*/