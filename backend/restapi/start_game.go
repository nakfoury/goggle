package restapi

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// swagger:route post /startGame startGame
//	Responses:
//		200:
var _ = register(func(r gin.IRoutes) {
	r.POST("/startGame", func(c *gin.Context) {
		var input startGameInput
		c.BindJSON(&input)

		// Find out what game ID is starting

		// Find out who's in that game and get those ws connections

		// Broadcast some stuff (starting; time; etc.)
		c.Status(http.StatusOK)
	})
})

type startGameInput struct {
	// required:true
	GameID string `json:"gameId"`
}

// swagger:parameters startGame
type _ struct {
	// in:body
	Body startGameInput
}
