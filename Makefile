# Various shortcuts, particularly for use during development.

# If running "make" with no target, then build.
.PHONY: default
default: build


# =========
#    RUN
# =========

# Use this to run a local backend API server (ports 8081 and 8082).
.PHONY: run-backend
run-backend:
	go run ./backend/cmd/httpbackend

# Use this to run a local web client server (port 5000).
.PHONY: run-client
run-client: yarn-install
	cd client && yarn run dev


# ============
#    PLEASE
# ============

# Please run this target once to install a git hook which will automatically validate code
# formatting and run unit tests before committing.
.PHONY: install-hook
install-hook:
	echo "#!/usr/bin/env sh\nmake pre-commit" > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit


# ===========
#    BUILD
# ===========

.PHONY: build
build: build-backend build-client

.PHONY: build-backend
build-backend:
	mkdir -p backend/bin
	go build -o backend/bin/restapi ./backend/cmd/restapi
	go build -o backend/bin/wsapi ./backend/cmd/wsapi

.PHONY: build-client
build-client: yarn-install
	cd client && yarn run build


# ==========
#    TEST
# ==========

.PHONY: test
test: test-backend test-client

.PHONY: test-backend
test-backend:
	go test -v ./backend/...

.PHONY: test-client
test-client: yarn-install
	cd client && yarn run test


# ============
#    DEPLOY
# ============

# Deploy everything to production (requires "goggle" AWS profile for authentication).
.PHONY: deploy
deploy: deploy-infra deploy-backend deploy-client

.PHONY: deploy-backend
deploy-backend:
	sh ./scripts/deploy_backend.sh

.PHONY: deploy-client
deploy-client:
	sh ./scripts/deploy_client.sh

.PHONY: deploy-infra
deploy-infra: fmt-terraform
ifneq (, $(shell which terraform))
	cd terraform && terraform init && terraform apply
else
	@echo Not deploying infrastructure because Terraform CLI is not installed
endif

.PHONY: deploy-infra-impatiently
deploy-infra-impatiently:
	cd terraform && terraform apply -auto-approve


# ====================
#    FIX FORMATTING
# ====================

# Reformat all code. Do this before committing.
.PHONY: fmt
fmt: fmt-backend fmt-client fmt-terraform

.PHONY: fmt-backend
fmt-backend:
	go run github.com/golangci/golangci-lint/cmd/golangci-lint run --fast --config ./backend/.golangci.yml --fix ./backend/...

.PHONY: fmt-client
fmt-client: yarn-install
	cd client && yarn run fmt

.PHONY: fmt-terraform
fmt-terraform:
ifneq (, $(shell which terraform))
	cd terraform && terraform fmt -recursive
else
	@echo Not formatting Terraform config because Terraform CLI is not installed
endif


# ==========
#    MISC
# ==========

.PHONY: yarn-install
yarn-install:
	cd client && yarn install

.PHONY: pre-commit
pre-commit: lint test

.PHONY: lint
lint: yarn-install
	go run github.com/golangci/golangci-lint/cmd/golangci-lint run --fast --config ./backend/.golangci.yml ./backend/...
	cd client && yarn run lint
ifneq (, $(shell which terraform))
	cd terraform && terraform fmt -recursive -check
else
	@echo Not linting Terraform config because Terraform CLI is not installed
endif
