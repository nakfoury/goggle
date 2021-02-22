# Goggle

A free word game!

https://freewordgame.com

## Development

### Requirements

- [Go](https://golang.org/doc/install)
- [Node.js](https://nodejs.org/)
- Yarn
  - `npm install -g yarn`
- (Optional) [Terraform v0.14.6](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  - _Only required if you plan on working on infrastructure._
- (Optional) [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  - _Only required if you plan on deploying the backend or client to production._

### Quick Start

We use `make` for easy-to-run shortcuts. Each shortcut will print out the commands it runs, if
you're curious.

1. Run the backend. The backend listens on http://localhost:8081 and ws://localhost:8082.

   ```shell
   $ make run-backend
   ```

2. In a second terminal, run the client. This serves the web client on http://localhost:5000, which
   you can open in a web browser.

   ```shell
   $ make run-client
   ```

   **Tip:** By default, the client runs against the local backend API server. To run against the
   production API, run this instead:

   ```shell
   $ PROD_API=1 make run-client
   ```

Everything should be running. You can work on the client code and it will hot-reload in your browser
at http://localhost:5000. The backend code doesn't hot-reload, so you'll need to re-run
`make run-backend` after making changes.

### Please

Run `make install-hook` once to install a git hook which will automatically validate code formatting
and run unit tests before committing.

```shell
$ make install-hook
```

Most formatting issues can be fixed automatically with `make fmt`.

```shell
$ make fmt
```

### About the Stack

#### Backend

The backend is written in [Go](https://golang.org/) and consists of a REST API and a websocket API.
The REST API is the main API. The websocket API is used to push realtime data to connected clients.

When running the backend locally these APIs are listening on ports 8081 and 8082; however in
production the backend is deployed to [AWS Lambda](https://aws.amazon.com/lambda/) functions,
fronted by an [AWS API Gateway](https://aws.amazon.com/api-gateway/). That is why the
`./backend/cmd/httpbackend` command, which is used to run the local server, looks so different from
`./backend/cmd/restapi` and `./backend/cmd/wsapi`, because the latter two are Lambda functions.

The REST API code lives in the `./backend/restapi` project directory, and the websocket API code
lives in `./backend/wsapi`.

The primary backend library to know is [Gin](https://github.com/gin-gonic/gin).

After making changes to the REST API code, run `make gen-tsclient` to regenerate the Typescript
client and models.

#### Client

The client is written in [Svelte](https://svelte.dev/), which is a component-based Javascript
library that is known for producing small Javascript builds and requiring very little boilerplate
code.

The `./client` project directory is a typical [Node.js](https://nodejs.org/) project structure.

We use the [Typescript](https://www.typescriptlang.org/) language for code and
[Less](http://lesscss.org/) for styles.

### References

#### [go-swagger](https://goswagger.io/use/spec.html)

The `./backend/wsapi` code is annotated using go-swagger annotations to aid Typescript client code
generation.

### Deployment

Deployment to production happens automatically inside GitHub Actions on pushes to the `main` branch.

You can also deploy to production by running `make deploy`. This requires AWS credentials in a
"goggle" named profile.
[See how to set up a profile here.](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)

```shell
$ make deploy
```

### Using the APIs

Try the REST API.

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
