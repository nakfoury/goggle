package restapi

import (
	"math/rand"

	"github.com/gin-gonic/gin"
)

// swagger:route post /startGame startGame
//	Responses:
//		200: body:startGameOutput
var _ = register(func(r gin.IRoutes) {
	r.POST("/startGame", func(c *gin.Context) {
		var input startGameInput
		c.BindJSON(&input)

		// Find out what game ID is starting

		// Load the game settings (like board size, for example)
		boardSize := 4

		// Find out who's in that game and get those ws connections

		// Broadcast some stuff (starting; time; board itself; etc.)

		bag := []byte("eeeeeeeeeeeeeeeeeeetttttttttttttaaaaaaaaaaaarrrrrrrrrrrriiiiiiiiiiinnnnnnnnnnnooooooooooosssssssssddddddccccchhhhhlllllffffmmmmppppuuuugggyyywwbjkqvxz")
		rand.Shuffle(len(bag), func(i, j int) { bag[i], bag[j] = bag[j], bag[i] })

		board := make([][]string, boardSize)

		for i := 0; i < boardSize; i++ {
			board[i] = make([]string, boardSize)
			for j := 0; j < boardSize; j++ {
				board[i][j], bag = string(bag[:1]), bag[1:]
			}
		}

		c.JSON(200, startGameOutput{
			Board: board,
		})
	})
})

type startGameInput struct {
	// required:true
	GameID string `json:"gameId"`
}

// swagger:model
type startGameOutput struct {
	// required:true
	Board [][]string `json:"board"`
}

// swagger:parameters startGame
type _ struct {
	// in:body
	Body startGameInput
}
