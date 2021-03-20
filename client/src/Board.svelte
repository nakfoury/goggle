<script lang="typescript">
  import { Api } from './Api'

  const resp = Api.startGame({ gameId: 'ABCD' })
</script>

{#await resp then resp}
  <div class="s-table__wrapper justify-center d-flex mt-12">
    <table class="s-table">
      {#each resp.data.board as x}
        <tr>
          {#each x as y}
            <td>{y.toUpperCase()}</td>
          {/each}
        </tr>
      {/each}
    </table>
  </div>
{/await}

<style lang="scss">
  @media only screen and (max-width: 960px) {
    td {
      font-size: 1em;
    }
  }

  td {
    border: thin solid var(--theme-dividers);
    height: 2em;
    width: 2em;
  }
</style>
