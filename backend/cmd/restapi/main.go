// Command restapi runs the Goggle REST API as an AWS Lambda function.
package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	ginadapter "github.com/awslabs/aws-lambda-go-api-proxy/gin"

	"github.com/nakfoury/goggle/backend/restapi"
)

func main() {
	// Initialize the handler, which is a normal http server.
	handler := restapi.Handler()

	// Wrap the handler in an adapter so that it can be invoked as a lambda.
	ginLambda := ginadapter.New(handler)

	// Start the AWS lambda.
	lambda.Start(func(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
		return ginLambda.ProxyWithContext(ctx, req)
	})
}
