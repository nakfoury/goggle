<script lang="ts">
  import { Button, Icon } from 'svelte-materialify'
  import { mdiWeatherNight, mdiWeatherSunny } from '@mdi/js'
  import { darkMode } from './globalStore'

  function toggleDarkMode() {
    darkMode.update((value) => !value)
  }
</script>

<Button fab text on:click={toggleDarkMode}>
  <Icon path={$darkMode ? mdiWeatherSunny : mdiWeatherNight} />
</Button>
