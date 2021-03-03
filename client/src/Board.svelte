<script lang="typescript">
  import { mdiViewDashboardVariant } from '@mdi/js'
  import { Api, StartGameInput, StartGameOutput } from './Api'
  import type { HttpResponse } from './Api'
  import { Table } from 'svelte-materialify/src'

  const resp = Api.startGame({ gameId: 'ABCD' })
</script>

{#await resp then resp}
  <div class="s-table__wrapper">
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
  table {
    font-size: 64pt;
    background: blue;
  }
</style>
