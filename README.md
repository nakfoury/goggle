# Goggle

A free word game!

## Development

Run the backend.

```shell
$ make run-backend
```

In a second terminal, try the REST API.

```shell
$ curl http://localhost:8081/hello
{"message":"Sorry, no games here."}
```

Try the websocket API.

```shell
$ npm install -g wscat  # Install this once if you do not have it
$ wscat -c ws://localhost:8082
Connected (press CTRL+C to quit)
> hello
< Sorry, no games here either!
```

## Production APIs

Try the REST API.

```shell
$ curl https://api.freewordgame.com/hello
{"message":"Sorry, no games here."}
```

Try the websocket API.

```shell
$ wscat -c wss://ws.freewordgame.com
Connected (press CTRL+C to quit)
> hello
< Sorry, no games here either!
```
