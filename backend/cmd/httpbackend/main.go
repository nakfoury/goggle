// Command httpbackend runs the Goggle Websocket API and REST API has local HTTP servers.
package main

import (
	"github.com/armsnyder/aws-websocket-adapter"
	"github.com/nakfoury/goggle/backend/restapi"
	"github.com/nakfoury/goggle/backend/wsapi"
	"golang.org/x/sync/errgroup"
	"log"
	"net/http"
)

func main() {
	var group errgroup.Group

	// Run both listeners concurrently in the background.
	group.Go(serveRESTAPI)
	group.Go(serveWSAPI)

	// Wait for one of the listeners to stop or encounter an error.
	err := group.Wait()

	if err != nil {
		log.Fatal(err)
	}
}

func serveRESTAPI() error {
	restServer := restapi.Handler()
	addr := ":8081"

	log.Printf("Listening and serving REST API on %s", addr)
	return http.ListenAndServe(addr, restServer)
}

func serveWSAPI() error {
	// Wrap the WSAPI handler in an adapter that can handle real websocket connections.
	wsServer := &awswebsocketadapter.Adapter{}
	wsServer.LambdaHandler = wsapi.Handler(wsServer)
	addr := ":8082"

	log.Printf("Listening and serving websocket API on %s", addr)
	return http.ListenAndServe(addr, wsServer)
}
