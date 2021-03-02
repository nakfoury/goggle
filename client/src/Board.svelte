<script lang="typescript">
  import { Table } from 'svelte-materialify/src'

  export let size = 4
</script>

<!-- <table class="s-table">
  {#each { length: size } as x}
    <tr>
      {#each { length: size } as y}
        <td>A</td>
      {/each}
    </tr>
  {/each}
</table> -->

<div class="s-table__wrapper">
  <table class="s-table">
    {#each { length: size } as x}
      <tr>
        {#each { length: size } as y}
          <td>A</td>
        {/each}
      </tr>
    {/each}
  </table>
</div>

<style lang="scss">
  table {
    font-size: 64pt;
    background: blue;
  }
</style>
