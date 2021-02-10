//+build tools

// Package tools is for utility commands which are never compiled into backend code.
// Listing tools here prevents them from being pruned from go.mod when running "go mod tidy".
package tools

import (
	_ "github.com/golangci/golangci-lint/cmd/golangci-lint"
)
