<script lang="ts">
  import { fade } from 'svelte/transition'
  import { cubicInOut } from 'svelte/easing'
  import { AppBar, Icon, Snackbar, Button } from 'svelte-materialify/src'
  import { mdiChevronDoubleUp, mdiWeatherNight, mdiWeatherSunny } from '@mdi/js'
  import { name, darkMode } from './globalStore'

  // Bind the current height of the header.
  let clientHeight = 0

  // Customize the popup fade-out animation to be slower and smoother.
  const popupFadeOut = (node: Element) =>
    fade(node, {
      duration: 1000,
      easing: cubicInOut,
    })

  // Double-bind the popup state, with initial state based on memory.
  let active = localStorage.getItem('hideDarkModePopup') !== 'true'

  $: if (!active || $darkMode) {
    // Hide popup on next visit.
    localStorage.setItem('hideDarkModePopup', 'true')
    // Force the popup to close early if the theme button was clicked.
    active = false
  }

  function toggleDarkMode() {
    darkMode.update((value) => !value)
  }
</script>

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

<!-- Dark mode reminder popup -->
<Snackbar
  bind:active
  class="primary-color"
  top
  right
  offsetY="{clientHeight + 8}px"
  style="min-width: 0"
  timeout={4000}
  transition={popupFadeOut}
>
  <span class="mr-2">Try dark mode!</span>
  <Icon style="color: inherit" path={mdiChevronDoubleUp} />
</Snackbar>
