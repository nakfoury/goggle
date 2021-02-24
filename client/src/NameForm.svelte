<script lang="ts">
  import { Api } from './Api'
  import type { HttpResponse, CreateGameOutput } from './Api'
  import {
    Button,
    TextField,
    Card,
    Container,
    Row,
    Col,
    Snackbar,
  } from 'svelte-materialify'

  let name = ''

  let resp: Promise<HttpResponse<CreateGameOutput>>

  function createGame() {
    resp = Api.createGame()
  }
</script>

<Container>
  <Row>
    <Col cols={8} offset={2}>
      <Card raised class="pa-8">
        <Row>
          <Col>
            <TextField bind:value={name}>Name</TextField>
          </Col>
        </Row>
        <Row>
          <Col class="d-flex justify-center">
            <Button on:click={createGame} disabled={name.length == 0}>
              Create Game
            </Button>
          </Col>
          <Col class="d-flex justify-center">
            <Button disabled={name.length == 0}>Join Game</Button>
          </Col>
        </Row>
      </Card>
    </Col>
  </Row>
</Container>

{#await resp then resp}
  {#if resp}
    <Snackbar class="green-text" bottom center timeout={5000}>
      The code is {resp.data.gameId}
    </Snackbar>
  {/if}
{:catch error}
  <Snackbar class="red-text" bottom center timeout={5000}>
    {error.message}
  </Snackbar>
{/await}
