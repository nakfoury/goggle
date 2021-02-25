<script lang="ts">
  import { Button, Icon } from 'svelte-materialify/src'
  import { mdiWeatherNight, mdiWeatherSunny } from '@mdi/js'
  import { darkMode } from './globalStore'

  function toggleDarkMode() {
    darkMode.update((value) => !value)
  }
</script>

<Button fab text aria-label="Toggle dark mode" on:click={toggleDarkMode}>
  <Icon path={$darkMode ? mdiWeatherSunny : mdiWeatherNight} />
</Button>
