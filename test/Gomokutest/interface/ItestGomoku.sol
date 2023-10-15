// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SGomoku } from "../../../Gomoku/SGomoku.sol";

interface ItestGomoku {
    struct TestUsers {
        SGomoku.Users alice;
        SGomoku.Users bob;
    }

}