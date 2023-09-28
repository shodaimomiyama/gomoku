// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SAnswerStructAndStorage} from "src/A2/interfaces/SAnswerStructAndStorage.sol";

contract AnswerStructAndStorage is SAnswerStructAndStorage {
    /**
        A-2. 構造体/ストレージアクセスを試す
    */
    mapping(address=> YourScore) public mscore;
    //addressがkey、YourScoreがvalue、mscoreは格納する変数
//https://qiita.com/tecchan/items/a1f27aff2f7b53320b7b
    function scores(address _key) public view returns (string memory, string memory, uint256) {
      return (mscore[_key].name, mscore[_key].description,mscore[_key].score);
    }
    
    function submitScoreWithCheat(YourScore memory _score) public {
      
      
      mscore[msg.sender].score = _score.score + 50;
      //変更後の_scoreをmscoreマッピングにmsg.senderのキーで保存
      // Note: Fill me!
    }
}
