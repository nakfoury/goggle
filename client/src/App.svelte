<script lang="ts">
  import { MaterialApp } from 'svelte-materialify/src'
  import WelcomeCard from './WelcomeCard.svelte'
  import Header from './Header.svelte'
  import Board from './Board.svelte'
  import { darkMode } from './globalStore'
</script>

<MaterialApp theme={$darkMode ? 'dark' : 'light'}>
  <Header />
  <WelcomeCard />
  <Board />
</MaterialApp>
