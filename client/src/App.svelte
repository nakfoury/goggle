<script lang="ts">
  import { Api } from './Api'
  import type { HttpResponse, CreateGameOutput } from './Api'
  import { Button, MaterialApp } from 'svelte-materialify'

  let resp: Promise<HttpResponse<CreateGameOutput>>

  function handleClick() {
    resp = Api.createGame()
  }
</script>

<MaterialApp theme="light">
  <div class="ma-3">
    <Button on:click={handleClick}>Create Game</Button>

    {#await resp}
      <p>a hot slice of p</p>
    {:then resp}
      {#if resp}
        <p>the code is {resp.data.gameId}</p>
      {/if}
    {:catch error}
      <p style="color: green">{error.message}</p>
    {/await}
  </div>
</MaterialApp>
