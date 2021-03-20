// Package restapi declares a REST http server.
package restapi

import (
	"github.com/gin-gonic/gin"
)

var routes []struct {
	path    string
	handler gin.HandlerFunc
}

func register(path string, handler gin.HandlerFunc) bool {
	routes = append(routes, struct {
		path    string
		handler gin.HandlerFunc
	}{
		path:    path,
		handler: handler,
	})
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
	for _, route := range routes {
		r.POST(route.path, route.handler)
		r.GET(route.path, route.handler)
	}

	return r
}
