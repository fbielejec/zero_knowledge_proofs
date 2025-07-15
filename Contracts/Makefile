PRIVATE_KEY ?= 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 # pkey of the first dev account 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 on the anvil network (prefunded with 10K ETH)

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: clean
clean: # Remove all node and compilation data
clean:
	git clean -fdx

.PHONY: deps
deps: # Install dependencies
deps:
	npm install

.PHONY: anvil
anvil: # Run local anvil node
anvil:
	anvil -p 8545

.PHONY: stop-anvil
stop-anvil: # Stop local anvil node
stop-anvil:
	pkill anvil

.PHONY: watch-contracts
watch-contracts: # watcher on the eth contracts. Scripts dir is watched by default
watch-contracts:
	forge build --watch src/*.sol test/*.sol

.PHONY: format-contracts
format-contracts: # Format solidity contracts
format-contracts:
	npx prettier --write --plugin=prettier-plugin-solidity 'src/*.sol' 'script/*.sol' 'test/*.sol'

.PHONY: lint-contracts
lint-contracts: # Lint solidity contracts
lint-contracts:
	npx solhint -c .solhint.json 'src/*.sol' 'script/*.sol'

.PHONY: compile-contracts
compile-contracts: # Compile solidity contracts
compile-contracts:
	forge build

.PHONY: test-contracts
test-contracts: # Run test suite
test-contracts:
	forge test -vv

.PHONY: deploy-contracts
deploy: # Deploy contracts
deploy:
	PRIVATE_KEY=$(PRIVATE_KEY) forge script script/DeployAdd.s.sol --broadcast --rpc-url anvil
