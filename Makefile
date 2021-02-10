default: build-backend

build-backend:
	mkdir -p backend/bin
	go build -o backend/bin/restapi ./backend/cmd/restapi
	go build -o backend/bin/wsapi ./backend/cmd/wsapi

run-backend:
	go run ./backend/cmd/httpbackend

deploy-backend:
	sh ./scripts/deploy_backend.sh

deploy-infra: fmt-terraform
	cd terraform && terraform init && terraform apply

deploy-infra-impatiently:
	cd terraform && terraform apply -auto-approve

fmt-terraform:
	cd terraform && terraform fmt -recursive

lint-backend:
	go run github.com/golangci/golangci-lint/cmd/golangci-lint run --config ./backend/.golangci.yml ./backend/...

lint-backend-fix:
	go run github.com/golangci/golangci-lint/cmd/golangci-lint run --config ./backend/.golangci.yml --fix ./backend/...

.PHONY: default build-backend run-backend deploy-backend deploy-infra deploy-infra-impatiently fmt-terraform lint-backend lint-backend-fix
