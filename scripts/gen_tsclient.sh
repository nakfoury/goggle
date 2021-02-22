#!/usr/bin/env sh

set -e

# Create a temporary file for writing the OpenAPI v2 spec.
swagger_yaml="$(mktemp)"

# Clean up the OpenAPI v2 spec when the script exits.
trap 'rm -rf "$swagger_yaml"' EXIT

# Generate the OpenAPI v2 spec.
go run github.com/go-swagger/go-swagger/cmd/swagger generate spec --output "$swagger_yaml" --scan-models --work-dir ./backend

# Show the generated spec (useful for debugging).
jq <"$swagger_yaml" || true

# Generate the Typescript client/models from the generated OpenAPI v2 spec.
cd client && yarn run swagger-typescript-api --path "$swagger_yaml" --output ./src --templates ./templates/static --module-name-index -1
