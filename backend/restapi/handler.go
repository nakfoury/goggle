// Package restapi declares a REST http server.
package restapi

import (
	"github.com/gin-gonic/gin"
)

var routes []func(r gin.IRoutes)

func register(fn func(r gin.IRoutes)) bool {
	routes = append(routes, fn)
	return true
}

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
	for _, fn := range routes {
		fn(r)
	}

	return r
}
