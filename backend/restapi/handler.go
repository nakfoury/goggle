// Package restapi declares a REST http server.
package restapi

import "github.com/gin-gonic/gin"

// Handler creates a new Goggle REST API server.
//
// The resulting server is a regular http.Serve server, so it needs to be wrapped in order to use it
// in an AWS Lambda.
func Handler() *gin.Engine {
	r := gin.Default()

	// Register API path handlers.
	r.GET("/hello", handleHello)

	return r
}

// handleHello is an example REST API route.
func handleHello(c *gin.Context) {
	c.JSON(200, gin.H{"message": "Sorry, no games here."})
}
