// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { AnswerNativeToken } from "src/A4/AnswerNativeToken.sol";
import { IAnswerNativeToken } from "src/A4/interfaces/IAnswerNativeToken.sol";
import { IQuestionNativeToken } from "./interfaces/IQuestionNativeToken.sol";

contract QuestionNativeToken is Test, IQuestionNativeToken {

    using stdStorage for StdStorage;

    IAnswerNativeToken yourContract;
    address yourContractAddress;

    function setUp() public {
        yourContract = new AnswerNativeToken();
        yourContractAddress = address(yourContract);

    }

    /**
        Q-4. ネイティブトークン支払いを試す
     */
    function test_Q4_NativeToken() public {
        TestVars memory vars;

        //deal:Sets an address' balance

        vars.alice.addr = makeAddr("Alice");
        vars.alice.score = 100;
        vm.deal(vars.alice.addr, 1 ether);
        vars.bob.addr = makeAddr("Bob");
        vars.bob.score = 60;
        vm.deal(vars.bob.addr, 2 ether);

        vm.prank(vars.alice.addr);
        yourContract.gimmeLicense(vars.alice);
        //アリスはそのままの状態でpassできるよ(ライセンスもらえるよ)(100,1ETH)

        vm.prank(vars.bob.addr);
        vm.expectRevert("You failed.");
        //ボブはこのままの状態ではfailedされるよ(60,2ETH)
        yourContract.gimmeLicense(vars.bob);

        vm.prank(vars.bob.addr);
        vm.expectRevert("You failed.");
        yourContract.gimmeLicense{value: 1e17}(vars.bob);
        //1e17 wei（0.1 ether）をvalueとして付与して、gimmeLicense関数を再度Bobと共に呼び出すことがfailedされる運命

        //1 ether = 10^18 wei:表記法 = 1e18

        (, vars.score) = yourContract.licenseHolders(vars.bob.addr);
        //((address), vars.score)
        assertEq(vars.score, 0);
        //実装でrevertされているから、実装の方(lisenceHolders)にはボブの(address(addr), uint256(score))は登録されていないので、空っぽ(0)が返ってくる

        vm.prank(vars.bob.addr);
        yourContract.gimmeLicense{value: 1 ether}(vars.bob);
        //ライセンスのvalueを1ETHで設定→getmmeLicenseのrequireが0.1ETH以上という条件にしているのでpass

        (, vars.score) = yourContract.licenseHolders(vars.bob.addr);
        assertEq(vars.score, vars.bob.score);
        //上で実装の方でgimmeLicense関数がpass(実行)しているから、licenseHoldersにcandidate(address(addr), uint256(score))が入っている
    }
}
