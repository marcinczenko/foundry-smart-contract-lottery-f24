-include .env

.PHONY: build deploy test test-sepolia coverage deploy-sepolia fund-subscription

build:; forge build

deploy:
	@echo "Deploying to Anvil"
	forge script script/DeployFundMe.s.sol --rpc-url $(ANVIL_RPC_URL) --account devKey --sender $(ANVIL_SENDER_ADDRESS) --password-file .password --broadcast

test:
	forge test

test-sepolia:
	forge test --fork-url $(SEPOLIA_RPC_URL)

coverage:
	forge coverage

deploy-sepolia:
	@echo "Deploying to sepolia"
	forge script script/DeployRaffle.s.sol --rpc-url $(SEPOLIA_RPC_URL) --account account1-dev-web3 --sender $(SEPOLIA_SENDER_ADDRESS) --password-file .password --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

fund-subscription:
	@echo "Funding chainlink subscription on SEPOLIA"
	forge script script/Interactions.s.sol:FundSubscription --rpc-url $(SEPOLIA_RPC_URL) --account account1-dev-web3 --sender $(SEPOLIA_SENDER_ADDRESS) --password-file .password --broadcast
