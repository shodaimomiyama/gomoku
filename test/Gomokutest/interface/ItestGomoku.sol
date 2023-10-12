// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SAnswerGomoku } from "../../../Gomoku/SAnswerGomoku.sol";

interface ItestGomoku {
    struct TestUsers {
        SAnswerGomoku.Users alice;
        SAnswerGomoku.Users bob;
    }

}