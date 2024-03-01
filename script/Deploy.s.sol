// SPDX-License-Identifier: The Unlicense
pragma solidity ^0.8.0;

import { Script, console2 } from "forge-std/Script.sol";

import { FraxlendPair } from "../src/contracts/FraxlendPair.sol";
import { FraxlendWhitelist } from "../src/contracts/FraxlendWhitelist.sol";
import { FraxlendPairHelper } from "../src/contracts/FraxlendPairHelper.sol";
import { FraxlendPairDeployer } from "../src/contracts/FraxlendPairDeployer.sol";

import { VariableInterestRate } from "./../src/contracts/VariableInterestRate.sol";
import { LinearInterestRate } from "./../src/contracts/LinearInterestRate.sol";

contract DeployFraxlend is Script {
    FraxlendPairHelper helper;
    FraxlendWhitelist whitelist;
    FraxlendPairDeployer deployer;

    VariableInterestRate variableRate;
    LinearInterestRate linearRate;

    function computeSalt(bytes32 initCodeHash) internal virtual returns (bytes32 salt) {
        string[] memory ffi = new string[](3);
        ffi[0] = "bash";
        ffi[1] = "create2.sh";
        ffi[2] = vm.toString(initCodeHash);
        vm.ffi(ffi);
        salt = vm.parseBytes32(vm.readLine(".temp"));
        try vm.removeFile(".temp") { } catch { }
    }

    function run() public virtual {
        vm.startBroadcast();

        helper = new FraxlendPairHelper{
            salt: computeSalt(keccak256(abi.encodePacked(type(FraxlendPairHelper).creationCode)))
        }(); // no constructor
        console2.log("FraxlendPairHelper: ", address(helper));

        whitelist = new FraxlendWhitelist{
            salt: computeSalt(keccak256(abi.encodePacked(type(FraxlendWhitelist).creationCode)))
        }();
        console2.log("FraxlendWhitelist: ", address(whitelist));

        whitelist.initialize(vm.envAddress("FRAXLEND_OWNER"));

        deployer = new FraxlendPairDeployer{
            salt: computeSalt(keccak256(abi.encodePacked(type(FraxlendPairDeployer).creationCode)))
        }();
        console2.log("FraxlendPairDeployer: ", address(deployer));

        deployer.initialize(
            vm.envAddress("FRAXLEND_OWNER"),
            vm.envAddress("FRAXLEND_CIRCUIT_BREAKER"),
            vm.envAddress("FRAXLEND_COMPTROLLER"),
            vm.envAddress("FRAXLEND_TIMELOCK"),
            address(whitelist)
        );

        deployer.setCreationCode(type(FraxlendPair).creationCode);

        variableRate = new VariableInterestRate{
            salt: computeSalt(keccak256(abi.encodePacked(type(VariableInterestRate).creationCode)))
        }(); // no constructor
        console2.log("VariableInterestRate: ", address(variableRate));

        linearRate = new LinearInterestRate{
            salt: computeSalt(keccak256(abi.encodePacked(type(LinearInterestRate).creationCode)))
        }(); // no constructor
        console2.log("LinearInterestRate: ", address(linearRate));

        vm.stopBroadcast();
    }
}
