<script lang="ts">
  import { AppBar, Icon, Button } from 'svelte-materialify/src'
  import { mdiWeatherNight, mdiWeatherSunny } from '@mdi/js'
  import { name, darkMode } from './globalStore'
  import TryDarkModePopup from './TryDarkModePopup.svelte'

  // Bind the current height of the header.
  let clientHeight = 0

  function toggleDarkMode() {
    darkMode.update((value) => !value)
  }
</script>

<!-- Header -->

<div bind:clientHeight>
  <AppBar>
    <!-- Main title -->
    <span slot="title">Goggle</span>

    <!-- Spacer -->
    <div class="flex-grow-1" />

    <!-- Right-aligned content -->

    <!-- Show user name -->
    <span class="mr-2">{$name}</span>

    <!-- Theme button -->
    <Button fab text aria-label="Toggle dark mode" on:click={toggleDarkMode}>
      <Icon path={$darkMode ? mdiWeatherSunny : mdiWeatherNight} />
    </Button>
  </AppBar>
</div>

<!-- One-time dark mode reminder popup -->

<TryDarkModePopup offsetY={clientHeight} />
