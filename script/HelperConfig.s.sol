// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";

abstract contract CodeConstants {
    /* VRF Mock Values */
    uint96 public MOCK_BASE_FEE = 0.25 ether;
    uint96 public MOCK_GAS_PRICE_LINK = 1e9;
    int256 public MOCK_WEI_PER_UNIT_LINK = 4e15;

    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is CodeConstants, Script {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint32 callbackGasLimit;
        uint256 subscriptionId;
        address link;
        address account;
    }

    NetworkConfig public localNetworkConfig;
    mapping(uint256 => NetworkConfig) public networkConfigs;

    constructor() {
        // Initialize empty struct
        localNetworkConfig = NetworkConfig({
            entranceFee: 0,
            interval: 0,
            vrfCoordinator: address(0),
            gasLane: bytes32(0),
            callbackGasLimit: 0,
            subscriptionId: 0,
            link: address(0),
            account: address(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38)
        });

        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
    }

    function getConfigByChainId(uint256 chainId) public view returns (NetworkConfig memory) {
        if (networkConfigs[chainId].vrfCoordinator != address(0)) {
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return localNetworkConfig; // Do not call a state-modifying function inside `view`
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getConfig() public view returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B),
            gasLane: bytes32(0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae),
            callbackGasLimit: 500000,
            subscriptionId: 0,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
            account: 0xa7F07AA1095b8ef74E604e70d39E216Effb4267c
        });
    }

    function createAnvilEthConfig() public {
        if (localNetworkConfig.vrfCoordinator != address(0)) {
            return;
        }

        // Deploy mocksfor
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinatorMock =
            new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE_LINK, MOCK_WEI_PER_UNIT_LINK);
        LinkToken linkToken = new LinkToken();
        vm.stopBroadcast();

        localNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(vrfCoordinatorMock),
            gasLane: bytes32(0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae),
            callbackGasLimit: 500000,
            subscriptionId: 0,
            link: address(linkToken),
            account: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        });
        require(localNetworkConfig.vrfCoordinator != address(0), "VRF Coordinator not set!");
    }
}
