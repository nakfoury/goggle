<script lang="ts">
  import { MaterialApp } from 'svelte-materialify'
  import WelcomeCard from './WelcomeCard.svelte'
  import { darkMode } from './globalStore'
  import Header from './Header.svelte'
</script>

<MaterialApp theme={$darkMode ? 'dark' : 'light'}>
  <Header />
  <WelcomeCard />
</MaterialApp>
