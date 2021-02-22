<script lang="ts">
  import { Api } from './Api'
  import type { HttpResponse, CreateGameOutput } from './Api'

  let resp: Promise<HttpResponse<CreateGameOutput>>

  function handleClick() {
    resp = Api.createGame()
  }
</script>

<button on:click={handleClick}>Create Game</button>

{#await resp}
  <p>a hot slice of p</p>
{:then resp}
  {#if resp}
    <p>the code is {resp.data.gameId}</p>
  {/if}
{:catch error}
  <p style="color: green">{error.message}</p>
{/await}
