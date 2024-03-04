// SPDX-License-Identifier: ISC
pragma solidity ^0.8.15;

import "./BasePairTest.sol";

contract FraxlendPairDeployerTest is BasePairTest {
    using stdStorage for StdStorage;
    using OracleHelper for AggregatorV3Interface;

    function testCannotDeployTwicePublic() public {
        // Setup contracts
        setExternalContracts();

        // Set initial oracle prices
        bytes memory _rateInitData = defaultRateInitForLinear();
        deployer.deploy(
            abi.encode(
                address(asset),
                address(collateral),
                address(oracleMultiply),
                address(oracleDivide),
                1e10,
                address(linearRateContract),
                _rateInitData
            )
        );

        // Test Starts
        bytes memory _rateInitData2 = defaultRateInitForLinear();
        vm.expectRevert("FraxlendPairDeployer: Pair already deployed");
        deployer.deploy(
            abi.encode(
                address(asset),
                address(collateral),
                address(oracleMultiply),
                address(oracleDivide),
                1e10,
                address(linearRateContract),
                _rateInitData2
            )
        );
    }

    function testCanDeployTwicePublic() public {
        // Setup contracts
        setExternalContracts();

        // Test Starts
        // Define some custom init data
        (uint256 MIN_INT, uint256 MAX_INT, uint256 MAX_VERTEX_UTIL, uint256 UTIL_PREC) = abi.decode(
            (new LinearInterestRate()).getConstants(), (uint256, uint256, uint256, uint256)
        );
        uint256 _minInterest = MIN_INT + 1;
        uint256 _vertexInterest = _minInterest * 60; // 10%
        uint256 _maxInterest = _minInterest * 400; // 100%
        uint256 _vertexUtilization = (80 * UTIL_PREC) / 100;
        deployer.deploy(
            _encodeConfigData(
                1e10,
                address(linearRateContract),
                abi.encode(_minInterest, _vertexInterest, _maxInterest, _vertexUtilization)
            )
        );
        mineOneBlock();
        // Use default init data
        deployer.deploy(
            _encodeConfigData(1e10, address(variableRateContract), defaultRateInitForLinear())
        );
    }

    function testCanDeployTwicePublicFRAXFXS() public {
        // Setup contracts
        setExternalContracts();

        // Test Starts
        deployer.deploy(
            abi.encode(
                FRAX_ERC20,
                WETH_ERC20,
                address(0),
                CHAINLINK_ETH_USD,
                1e10,
                address(variableRateContract),
                abi.encode()
            )
        );
        mineOneBlock();
        deployer.deploy(
            abi.encode(
                FXS_ERC20,
                WETH_ERC20,
                CHAINLINK_FXS_USD,
                CHAINLINK_ETH_USD,
                1e18,
                address(variableRateContract),
                abi.encode()
            )
        );
    }

    function testCanDeployTwiceCustom() public {
        // Setup contracts
        setExternalContracts();

        // Test Starts
        // different Init Data
        (uint256 MIN_INT, uint256 MAX_INT, uint256 MAX_VERTEX_UTIL, uint256 UTIL_PREC) = abi.decode(
            (new LinearInterestRate()).getConstants(), (uint256, uint256, uint256, uint256)
        );
        uint256 _minInterest = MIN_INT + 1;
        uint256 _vertexInterest = _minInterest * 60; // 10%
        uint256 _maxInterest = _minInterest * 400; // 100%
        uint256 _vertexUtilization = (80 * UTIL_PREC) / 100;

        deployer.deployCustom(
            "My cool contract",
            _encodeConfigData(
                1e10,
                address(linearRateContract),
                abi.encode(_minInterest, _vertexInterest, _maxInterest, _vertexUtilization)
            ),
            DEFAULT_MAX_LTV,
            DEFAULT_LIQ_FEE,
            0,
            1000,
            new address[](0),
            new address[](0)
        );

        mineOneBlock();

        deployer.deployCustom(
            "me second",
            _encodeConfigData(1e10, address(variableRateContract), defaultRateInitForLinear()),
            DEFAULT_MAX_LTV,
            DEFAULT_LIQ_FEE,
            0,
            1000,
            new address[](0),
            new address[](0)
        );
    }
}
