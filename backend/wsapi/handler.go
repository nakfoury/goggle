// Package wsapi declares an AWS Lambda handler function for use with a websocket API Gateway.
package wsapi

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go/service/apigatewaymanagementapi"
	"github.com/aws/aws-sdk-go/service/apigatewaymanagementapi/apigatewaymanagementapiiface"
)

// Handler creates a new Goggle Websocket API handler function.
//
// The resulting handler can be invoked with lambda.Start directly. It needs to be wrapped in order
// to use it as a real websocket server.
func Handler(apiGatewayClient apigatewaymanagementapiiface.ApiGatewayManagementApiAPI) func(context.Context, events.APIGatewayWebsocketProxyRequest) (events.APIGatewayProxyResponse, error) {
	return func(ctx context.Context, req events.APIGatewayWebsocketProxyRequest) (events.APIGatewayProxyResponse, error) {
		return handler(ctx, req, apiGatewayClient)
	}
}

func handler(ctx context.Context, req events.APIGatewayWebsocketProxyRequest, apiGatewayClient apigatewaymanagementapiiface.ApiGatewayManagementApiAPI) (resp events.APIGatewayProxyResponse, err error) {
	// Handle the event.
	switch req.RequestContext.EventType {
	case "CONNECT":
		err = handleConnect(ctx, req)
	case "DISCONNECT":
		err = handleDisconnect(ctx, req)
	case "MESSAGE":
		err = handleMessage(ctx, req, apiGatewayClient)
	default:
		err = fmt.Errorf("invalid event type %q", req.RequestContext.EventType)
	}

	if err != nil {
		log.Printf("Error while handling %q event from connection %q: %v",
			req.RequestContext.EventType, req.RequestContext.ConnectionID, err)
	}

	// The response status code is always 200, even when there is an error.
	resp = events.APIGatewayProxyResponse{StatusCode: 200}

	return resp, err
}

func handleConnect(ctx context.Context, req events.APIGatewayWebsocketProxyRequest) error {
	log.Printf("Handling new connection from %q", req.RequestContext.ConnectionID)
	return nil
}

func handleDisconnect(ctx context.Context, req events.APIGatewayWebsocketProxyRequest) error {
	log.Printf("Handling disconnect from %q", req.RequestContext.ConnectionID)
	return nil
}

func handleMessage(ctx context.Context, req events.APIGatewayWebsocketProxyRequest, client apigatewaymanagementapiiface.ApiGatewayManagementApiAPI) error {
	log.Printf("Incoming message from %q: %s", req.RequestContext.ConnectionID, req.Body)

	reply := &apigatewaymanagementapi.PostToConnectionInput{
		ConnectionId: &req.RequestContext.ConnectionID,
		Data:         []byte(`Sorry, no games here either!`),
	}

	_, err := client.PostToConnectionWithContext(ctx, reply)
	return err
}
