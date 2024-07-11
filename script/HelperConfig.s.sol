// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";

abstract contract CodeConstants {
    /* VFR Mock Values */
    uint96 public constant MOCK_BASE_FEE = 0.25 ether;
    uint96 public constant MOCK_GAS_PRICE_LINK = 1e9;

    /* LINK/ETH Price */
    int256 public constant MOCK_WEI_PER_UNIT_LINK = 4e15;

    /* NETWORKS */
    uint256 public constant SEPOLIA_CHAINID = 11155111;
    uint256 public constant MAINNET_CHAINID = 1;
    uint256 public constant ANVIL_CHAINID = 31337;
}

contract HelperConfig is CodeConstants, Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
        address link;
    }

    uint8 private constant DECIMALS = 8;
    int256 private constant INITIAL_ANSWER = 2000e8;

    mapping(uint256 => NetworkConfig) private networkConfigs;

    constructor() {
        if (block.chainid == SEPOLIA_CHAINID) {
            createSepoliaEthConfig();
        } else if (block.chainid == MAINNET_CHAINID) {
            createMainnetEthConfig();
        } else {
            createAnvilEthConfig();
        }
    }

    function createSepoliaEthConfig() private {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            entranceFee: 0.1 ether,
            interval: 30, // 30 seconds
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            subscriptionId: 7913878014749387412333169404015339454317919373482546433289430420402927208210,
            callbackGasLimit: 500000,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789
        });

        networkConfigs[SEPOLIA_CHAINID] = sepoliaConfig;
    }

    function createMainnetEthConfig() private {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            entranceFee: 0.1 ether,
            interval: 30, // 30 seconds
            vrfCoordinator: 0xD7f86b4b8Cae7D942340FF628F82735b7a20893a,
            gasLane: 0x8077df514608a09f83e4e8d300645594e5d7234665448ba83f51a50f842bd3d9,
            subscriptionId: 0,
            callbackGasLimit: 500000,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789
        });

        networkConfigs[MAINNET_CHAINID] = mainnetConfig;
    }

    function createAnvilEthConfig() private {
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock vrfCoordinatorMock =
            new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE_LINK, MOCK_WEI_PER_UNIT_LINK);
        LinkToken linkToken = new LinkToken();
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            entranceFee: 0.1 ether,
            interval: 30, // 30 seconds
            vrfCoordinator: address(vrfCoordinatorMock),
            // gasLane does not matter for the mock
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            subscriptionId: 0,
            callbackGasLimit: 500000,
            link: address(linkToken)
        });
        networkConfigs[block.chainid] = anvilConfig;
    }

    function activeNetworkConfig() public view returns (NetworkConfig memory) {
        return networkConfigs[block.chainid];
    }
}
