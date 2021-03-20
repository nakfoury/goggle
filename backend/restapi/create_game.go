package restapi

import (
	"github.com/gin-gonic/gin"
)

// swagger:route post /createGame createGame
//	Responses:
//		200: body:createGameOutput
var _ = register(func(r gin.IRoutes) {
	r.Any("/createGame", func(c *gin.Context) {
		c.JSON(200, createGameOutput{GameID: "ABCD"})
	})
})

// swagger:model
type createGameOutput struct {
	// required: true
	GameID string `json:"gameId"`
}
