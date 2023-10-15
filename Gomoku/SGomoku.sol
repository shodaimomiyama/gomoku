// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface SGomoku {

    struct Users {
        address addr;
        uint256 wincount;
        uint256 losecount;
        uint256 fightcount;
    }

    struct GameSetting {
        uint[15][15] grid;
        uint256 gid;
        bool canStart;
        bool canContinue;
        bool canEnd;
    }


}