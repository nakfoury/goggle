<script lang="ts">
  import { Api } from './Api'
  import type { HttpResponse, CreateGameOutput } from './Api'
  import {
    Button,
    TextField,
    Row,
    Col,
    Snackbar,
    Icon,
  } from 'svelte-materialify'
  import { mdiAccountSwitch, mdiPlus } from '@mdi/js'
  import { createEventDispatcher } from 'svelte'
  import { name } from './globalStore'

  let value = $name

  let resp: Promise<HttpResponse<CreateGameOutput>>

  function handleClickCreateGame() {
    name.set(value)
    resp = Api.createGame()
  }

  const dispatch = createEventDispatcher()

  function handleClickJoinGame() {
    name.set(value)
    dispatch('join')
  }

  const counter = 20

  const rules: ((value: string) => string | true)[] = [
    (value) => !!value?.length || 'Name required',
    (value) =>
      (value?.length ?? 0) <= counter ||
      `Name cannot be longer than ${counter} characters`,
    (value) =>
      /^[A-Za-z0-9 _-]*$/.test(value) || 'Name contains illegal characters',
  ]

  let error = false

  $: disabled = error || !value.length
</script>

<Row>
  <Col>
    <TextField bind:value bind:error {counter} {rules}>Name</TextField>
  </Col>
</Row>
<Row class="mt-8">
  <Col>
    <Button
      class={disabled ? undefined : 'secondary-color'}
      block
      tile
      {disabled}
      on:click={handleClickCreateGame}
    >
      <Icon path={mdiPlus} />
      <div class="flex-grow-1">Create Game</div>
    </Button>
  </Col>
</Row>
<Row>
  <Col>
    <Button
      class={disabled ? undefined : 'primary-color'}
      block
      tile
      {disabled}
      on:click={handleClickJoinGame}
    >
      <Icon path={mdiAccountSwitch} />
      <div class="flex-grow-1">Join Game</div>
    </Button>
  </Col>
</Row>

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
