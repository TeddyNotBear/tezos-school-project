ifndef LIGO 
    LIGO = docker run --rm -v "${PWD}":"${PWD}" -w "${PWD}" ligolang/ligo:0.57.0
endif

compile = $(LIGO) compile contract $(1) -o $(2) $(3)
testing = $(LIGO) run test ./contract_1/tests/$(1)

default: help

help: 
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  clean            - Cleans the compiled contracts"
	@echo "  compile          - Compiles contracts to Michelson"
	@echo "  deploy           - Deploys the main contract"
	@echo "  help             - Shows this help message"
	@echo "  recompile        - Cleans and compiles contracts"
	@echo "  sandbox-start    - Starts a sandbox"
	@echo "  sandbox-stop     - Stops the sandbox"
	@echo "  test             - Runs tests"
	@echo "  test-ligo        - Runs Ligo tests"
	@echo "  test-integration - Runs integration tests"

clean:
	@echo "Cleaning..."
	@rm -rf ./contract_1/src/compiled/*
	@echo "Cleaned successfully"

compile: 
	@echo "Compiling Main contract..."
	@$(call compile,./contract_1/src/contracts/main.mligo,./contract_1/src/compiled/main.tz)
	@$(call compile,./contract_1/src/contracts/main.mligo,./contract_1/src/compiled/main.json,--michelson-format json)
	@$(call compile,./contract_2/src/contracts/main.mligo,./contract_2/src/compiled/main.tz)
	@$(call compile,./contract_2/src/contracts/main.mligo,./contract_2/src/compiled/main.json,--michelson-format json)
	@echo "Compiled successfully"

deploy-contract:
	@echo "Deploying Main contract..."
	@npm run deploy

recompile: clean compile

sandbox-start: 
	@./scripts/run-sandbox.sh

sandbox-stop:
	@docker stop sandbox

test: test-ligo test-integration

test-ligo:
	@echo "Testing contracts..."
	@$(call testing,main.test.mligo)
	@echo "Tested successfully"

test-integration:
	@echo "Testing integration..."