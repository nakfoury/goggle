<script lang="ts">
  import { AppBar, Tooltip, Icon } from 'svelte-materialify/src'
  import { mdiChevronDoubleUp } from '@mdi/js'
  import ThemeButton from './ThemeButton.svelte'
  import { name, triedDarkMode } from './globalStore'

  // Hide the dark mode tooltip for a subsequent visit, even if the user doesn't click the button.
  let darkModeToolTipActive = true
  $: if (!darkModeToolTipActive) {
    triedDarkMode.set(true)
  }
</script>

<AppBar>
  <!-- Main title -->
  <span slot="title">Goggle</span>

  <!-- Spacer -->
  <div class="flex-grow-1" />

  <!-- Right-aligned content -->

  <!-- Show user name -->
  <span class="mr-2">{$name}</span>

  <!-- Only show the dark mode tooltip on the first visit. -->
  {#if $triedDarkMode}
    <ThemeButton />
  {:else}
    <Tooltip class="primary-color" bottom bind:active={darkModeToolTipActive}>
      <span slot="tip">
        <span>Try dark mode!</span>
        <Icon class="ml-2" path={mdiChevronDoubleUp} />
      </span>
      <ThemeButton />
    </Tooltip>
  {/if}
</AppBar>
