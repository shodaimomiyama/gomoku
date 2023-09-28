// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAnswerConditionalCheck } from "src/A3/interfaces/IAnswerConditionalCheck.sol";
import { SAnswerConditionalCheck } from "src/A3/interfaces/SAnswerConditionalCheck.sol";

contract AnswerConditionalCheck is IAnswerConditionalCheck, SAnswerConditionalCheck {

    /**
        A-3. 制御構文(if, for, require, revert), modifier, アクセス制御, オーナー権限を試す
     */
    
    mapping(address => Person) public persons;
    
    function borrowMore(Person memory person, uint256 amount)
        external override onlyYou(person) returns (bool)
    {
        require(amount > 0);

        //||:or
        require(person.debt == 0 || (100 * (person.collateral / person.debt))  > 110, "Collateralization ratio is already too low");
        
        uint256 newDebt = person.debt + amount;
        uint256 collateralizationRate = (person.collateral * 100) / newDebt;

    
        //担保率が110%以下の場合、エラーを返す
        require(collateralizationRate > 110, "Collateralization ratio must be more than 110%");

        //新しい負債額を更新
        
        // Note: Fill me!
        return true;
    }

    modifier onlyYou(Person memory person) {
        //呼び出すアカウントが指定されたPersonのアドレスと一致しない場合、エラーを返す
        require(msg.sender == person.addr, "You are not the owner of this account.");
        // Note: Fill me!
        _;
    }
}
