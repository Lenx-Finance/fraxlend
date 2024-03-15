// SPDX-License-Identifier: The Unlicense
pragma solidity ^0.8.0;

import { Script } from "forge-std/Script.sol";
import { MockERC20 } from "forge-std/mocks/MockERC20.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { FraxlendPair } from "../src/contracts/FraxlendPair.sol";
import { FraxlendPairHelper } from "../src/contracts/FraxlendPairHelper.sol";
import { FraxlendPairDeployer } from "../src/contracts/FraxlendPairDeployer.sol";

import { VariableInterestRate } from "../src/contracts/VariableInterestRate.sol";
import { LinearInterestRate } from "../src/contracts/LinearInterestRate.sol";

import { MockOracle } from "../test/mocks/MockOracle.sol";

contract DeployFraxlend is Script, StdCheats {
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
            LinearInterestRate linearRate,
            FraxlendPair pair
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

        if (vm.envBool("DEVNET")) {
            // deploy mocks
            MockERC20 xbtc = new MockERC20();
            xbtc.initialize("xBTC", "xBTC", 8);

            MockERC20 dai = new MockERC20();
            dai.initialize("DAI", "DAI", 18);

            // deal testnet balances
            deal(address(xbtc), msg.sender, 100e8);
            deal(address(dai), msg.sender, 100_000_000e18);

            pair = FraxlendPair(
                deployer.deploy(
                    abi.encode(
                        address(xbtc),
                        address(dai),
                        new MockOracle(18, 70_000e18), // 70k
                        new MockOracle(18, 1e18),
                        uint256(1e18),
                        address(variableRate),
                        abi.encode()
                    )
                )
            );
        }

        vm.stopBroadcast();
    }
}

contract DeployFraxlendPair is Script {
    function run() public virtual returns (FraxlendPair pair) {
        return FraxlendPair(
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
            )
        );
    }
}
