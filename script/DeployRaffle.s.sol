// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";

import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function deploy() public returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory activeNetworkConfig = helperConfig.activeNetworkConfig();

        if (activeNetworkConfig.subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription();
            (activeNetworkConfig.subscriptionId,) =
                createSubscription.createSubscription(activeNetworkConfig.vrfCoordinator);
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(
                activeNetworkConfig.vrfCoordinator, activeNetworkConfig.subscriptionId, activeNetworkConfig.link
            );
        }

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            activeNetworkConfig.entranceFee,
            activeNetworkConfig.interval,
            activeNetworkConfig.vrfCoordinator,
            activeNetworkConfig.gasLane,
            activeNetworkConfig.subscriptionId,
            activeNetworkConfig.callbackGasLimit
        );
        vm.stopBroadcast();
        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(address(raffle), activeNetworkConfig.vrfCoordinator, activeNetworkConfig.subscriptionId);
        return (raffle, helperConfig);
    }

    function run() public {
        deploy();
    }
}
