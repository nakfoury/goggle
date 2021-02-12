<script>
  function handleClick() {
    promise = createGame()
  }

  let promise

  async function createGame() {
    const res = await fetch(`http://localhost:8081/create`)
    const { code } = await res.json()
    return code
  }
</script>

<p>Free games take time.</p>

<button on:click={handleClick}>hello flame</button>

{#await promise}
  <p>a hot slice of p</p>
{:then code}
  {#if code}
    <p>the code is {code}</p>
  {/if}
{:catch error}
  <p style="color: green">{error.message}</p>
{/await}
