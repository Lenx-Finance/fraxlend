// SPDX-License-Identifier: The Unlicense
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";

import {FraxlendPair} from "../src/contracts/FraxlendPair.sol";
import {FraxlendPairHelper} from "../src/contracts/FraxlendPairHelper.sol";
import {FraxlendWhitelist} from "../src/contracts/FraxlendWhitelist.sol";
import {FraxlendPairDeployer} from "../src/contracts/FraxlendPairDeployer.sol";

import {VariableInterestRate} from "./../src/contracts/VariableInterestRate.sol";
import {LinearInterestRate} from "./../src/contracts/LinearInterestRate.sol";

contract DeployFraxlend is Script {
    FraxlendPairHelper helper;
    FraxlendWhitelist whitelist;
    FraxlendPairDeployer deployer;

    VariableInterestRate variableRate;
    LinearInterestRate linearRate;

    function run() public virtual {
        vm.startBroadcast();

        helper = new FraxlendPairHelper();
        console2.log("FraxlendPairHelper: ", address(helper));

        whitelist = new FraxlendWhitelist();
        console2.log("FraxlendWhitelist: ", address(whitelist));

        deployer = new FraxlendPairDeployer(
            vm.envAddress("FRAXLEND_CIRCUIT_BREAKER"),
            vm.envAddress("FRAXLEND_COMPTROLLER"),
            vm.envAddress("FRAXLEND_TIMELOCK"),
            address(whitelist)
        );
        console2.log("FraxlendPairDeployer: ", address(deployer));

        deployer.setCreationCode(type(FraxlendPair).creationCode);

        variableRate = new VariableInterestRate();
        console2.log("VariableInterestRate: ", address(variableRate));

        linearRate = new LinearInterestRate();
        console2.log("LinearInterestRate: ", address(linearRate));

        vm.stopBroadcast();
    }
}
