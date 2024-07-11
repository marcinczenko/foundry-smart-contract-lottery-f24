// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig, CodeConstants} from "script/HelperConfig.s.sol";

import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/LinkToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.activeNetworkConfig().vrfCoordinator;
        (uint256 subId,) = createSubscription(vrfCoordinator);
        return (subId, vrfCoordinator);
    }

    function createSubscription(address vfrCoordinator) public returns (uint256, address) {
        console.log("Creating subscription on chainId: ", block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vfrCoordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Your subscription id is: ", subId);
        console.log("Please update your id in your HelperConfig.s.sol contract.");
        return (subId, vfrCoordinator);
    }

    function run() public {
        createSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script, CodeConstants {
    uint256 public constant FUND_AMOUNT = 3 ether;

    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.activeNetworkConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.activeNetworkConfig().subscriptionId;
        address linkToken = helperConfig.activeNetworkConfig().link;
        fundSubscription(vrfCoordinator, subscriptionId, linkToken);
    }

    function fundSubscription(address vfrCoordinator, uint256 subsciptionId, address linkToken) public {
        console.log("Funding subscription: ", subsciptionId);
        console.log("using vfrCoordinator: ", vfrCoordinator);
        console.log("with chainId: ", block.chainid);
        if (block.chainid == ANVIL_CHAINID) {
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vfrCoordinator).fundSubscription(subsciptionId, FUND_AMOUNT * 100);
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            LinkToken(linkToken).transferAndCall(vfrCoordinator, FUND_AMOUNT, abi.encode(subsciptionId));
            vm.stopBroadcast();
            console.log("Subscription funded.");
        }
    }

    function run() public {
        fundSubscriptionUsingConfig();
    }
}

contract AddConsumer is Script {
    function addConsumerUsingConfig(address mostRecentlyDeployedContract) public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.activeNetworkConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.activeNetworkConfig().subscriptionId;
        addConsumer(mostRecentlyDeployedContract, vrfCoordinator, subscriptionId);
    }

    function addConsumer(address contractToAddToVrf, address vrfCoordinator, uint256 subsciptionId) public {
        console.log("Adding consumer contract: ", contractToAddToVrf);
        console.log("to subscription: ", subsciptionId);
        console.log("using vfrCoordinator: ", vrfCoordinator);
        console.log("with chainId: ", block.chainid);
        vm.startBroadcast();
        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subsciptionId, contractToAddToVrf);
        vm.stopBroadcast();
        console.log("Consumer contract added to subscription.");
    }

    function run() public {
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment("Raffle", block.chainid);
        addConsumerUsingConfig(mostRecentlyDeployedContract);
    }
}
