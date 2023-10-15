// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SGomoku } from "./SGomoku.sol";

interface IGomoku {

//GomokuV1
    function openGame(SGomoku.Users memory user) external returns(uint256); //addressが引数にならないかん
    function games() external returns(address, uint256, uint256, uint256);
    function getGameLen() external;
    function listGame() external;
    function joinGame(uint targetGid) external;

//GameV1
    function getPlayer1() external;
    function getplayer2() external;
    function startGame() external;
    function addstone() external;
    function judge() external;

}