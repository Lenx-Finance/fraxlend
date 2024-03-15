// SPDX-License-Identifier: The Unlicense
pragma solidity ^0.8.0;

import { Script, console2 } from "forge-std/Script.sol";

import { FraxlendPair } from "../src/contracts/FraxlendPair.sol";
import { FraxlendPairHelper } from "../src/contracts/FraxlendPairHelper.sol";
import { FraxlendPairDeployer } from "../src/contracts/FraxlendPairDeployer.sol";

import { VariableInterestRate } from "./../src/contracts/VariableInterestRate.sol";
import { LinearInterestRate } from "./../src/contracts/LinearInterestRate.sol";

contract DeployFraxlend is Script {
    function computeSalt(bytes32 initCodeHash) internal virtual returns (bytes32 salt) {
        string[] memory ffi = new string[](3);
        ffi[0] = "bash";
        ffi[1] = "create2.sh";
        ffi[2] = vm.toString(initCodeHash);
        vm.ffi(ffi);
        salt = vm.parseBytes32(vm.readLine(".temp"));
        try vm.removeFile(".temp") { } catch { }
    }

    function run()
        public
        virtual
        returns (
            FraxlendPairHelper helper,
            FraxlendPairDeployer deployer,
            VariableInterestRate variableRate,
            LinearInterestRate linearRate
        )
    {
        vm.startBroadcast();

        helper = new FraxlendPairHelper{
            salt: computeSalt(keccak256(type(FraxlendPairHelper).creationCode))
        }(); // no constructor

        deployer = new FraxlendPairDeployer{
            salt: computeSalt(keccak256(type(FraxlendPairDeployer).creationCode))
        }();

        deployer.initialize(
            vm.envAddress("FRAXLEND_OWNER"),
            vm.envAddress("FRAXLEND_CIRCUIT_BREAKER"),
            vm.envAddress("FRAXLEND_COMPTROLLER"),
            vm.envAddress("FRAXLEND_TIMELOCK")
        );

        deployer.setCreationCode(type(FraxlendPair).creationCode);

        variableRate = new VariableInterestRate{
            salt: computeSalt(keccak256(type(VariableInterestRate).creationCode))
        }(); // no constructor

        linearRate = new LinearInterestRate{
            salt: computeSalt(keccak256(type(LinearInterestRate).creationCode))
        }(); // no constructor

        vm.stopBroadcast();
    }
}

contract DeployFraxlendPair is Script {
    function run() public virtual returns (FraxlendPair pair) {
        FraxlendPairDeployer(vm.envAddress("FRAXLEND_PAIR_DEPLOYER")).deploy(
            abi.encode(
                vm.envAddress("FRAXLEND_ASSET"),
                vm.envAddress("FRAXLEND_COLLATERAL"),
                vm.envAddress("ORACLE_MULTIPLY"),
                vm.envAddress("ORACLE_DIVIDE"),
                vm.envUint("ORACLE_NORMALIZATION"),
                vm.envAddress("RATE_CONTRACT"),
                vm.envBytes("RATE_INIT_DATA")
            )
        );
    }
}
