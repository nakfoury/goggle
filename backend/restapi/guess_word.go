package restapi

import (
	"bufio"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

var dictionary = make(map[string]bool)

func init() {
	f, err := os.Open("dictionary.txt")
	if err != nil {
		panic(err)
	}
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		dictionary[scanner.Text()] = true
	}
}

// swagger:route post /guessWord guessWord
//	Responses:
//		200: body:guessWordOutput
var _ = register(func(r gin.IRoutes) {
	r.POST("/guessWord", func(c *gin.Context) {
		var input guessWordInput
		c.BindJSON(&input)
		c.JSON(200, guessWordOutput{Correct: dictionary[strings.ToUpper(input.Word)]})
	})
})

type guessWordInput struct {
	// required:true
	Word string `json:"word"`
}

// swagger:model
type guessWordOutput struct {
	// required: true
	Correct bool `json:"correct"`
}

// swagger:parameters guessWord
type _ struct {
	// in:body
	Body guessWordInput
}
