// Command wsapi runs the Goggle Websocket API as an AWS Lambda function.
package main

import (
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/apigatewaymanagementapi"
	"github.com/nakfoury/goggle/backend/wsapi"
	"log"
	"os"
)

func main() {
	// Create an API Gateway Management API client, for sending messages back to a connected client.
	apiGatewayInvokeURL := os.Getenv("API_GATEWAY_INVOKE_URL")
	if apiGatewayInvokeURL == "" {
		log.Fatal("Environment variable API_GATEWAY_INVOKE_URL is required.")
	}
	config := aws.NewConfig().WithEndpoint(apiGatewayInvokeURL)
	sess := session.Must(session.NewSession(config))
	apiGatewayClient := apigatewaymanagementapi.New(sess)

	// Initialize the handler.
	handler := wsapi.Handler(apiGatewayClient)

	// Start the AWS lambda.
	lambda.Start(handler)
}
