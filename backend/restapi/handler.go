// Package restapi declares a REST http server.
package restapi

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// Handler creates a new Goggle REST API server.
//
// The middleware argument is optional.
// The resulting server is a regular http.Serve server, so it needs to be wrapped in order to use it
// in an AWS Lambda.
func Handler(middleware ...gin.HandlerFunc) *gin.Engine {
	r := gin.Default()

	// Register passed-in middleware.
	r.Use(middleware...)

	// Register API path handlers.
	r.GET("/hello", handleHello)
	r.GET("/create", handleCreateGame)
	r.GET("/start", handleStartGame)

	return r
}

// handleHello is an example REST API route.
func handleHello(c *gin.Context) {
	c.JSON(200, gin.H{"message": "Sorry, no games here."})
}

func handleCreateGame(c *gin.Context) {
	c.JSON(200, gin.H{
		"code": "ABCD",
	})
}

func handleStartGame(c *gin.Context) {
	// Find out what game ID is starting

	// Find out who's in that game and get those ws connections

	// Broadcast some stuff (starting; time; etc.)
	c.Status(http.StatusAccepted)
}
