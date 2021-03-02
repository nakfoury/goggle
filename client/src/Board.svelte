<script lang="typescript">
  import { Table } from 'svelte-materialify/src'

  export let size = 4
</script>

<Table dense class="board">
  {#each { length: size } as x}
    <tr>
      {#each { length: size } as y}
        <td>A</td>
      {/each}
    </tr>
  {/each}
</Table>

<style lang="scss">
  .board {
    font-size: 100pt;
    background: blue;
  }
</style>
