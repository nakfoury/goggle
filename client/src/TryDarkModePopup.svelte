<script lang="ts">
  import { onMount } from 'svelte'
  import { fade } from 'svelte/transition'
  import { cubicInOut } from 'svelte/easing'
  import { Icon, Snackbar } from 'svelte-materialify/src'
  import { mdiChevronDoubleUp } from '@mdi/js'
  import { darkMode } from './globalStore'

  export let offsetY = 0

  // Customize the popup fade-out animation to be slower and smoother.
  const popupFadeOut = (node: Element) =>
    fade(node, {
      duration: 1000,
      easing: cubicInOut,
    })

  // Double-bind the popup state.
  let active = false

  // Save the popup activation timeout so we can cancel it.
  let popupTimeout: NodeJS.Timeout

  // We have to use onMount because we will be assigning to a bound variable.
  onMount(() => {
    if (!$darkMode && localStorage.getItem('hideDarkModePopup') !== 'true') {
      // Reveal the popup after a delay so it is noticable that it appears.
      // Save the popup activation timeout so we can cancel it.
      popupTimeout = setTimeout(() => {
        active = true

        // Hide the popup after a further delay, and save state
        // so it is hidden on a subsequent visit.
        setTimeout(() => {
          active = false
          localStorage.setItem('hideDarkModePopup', 'true')
        }, 6000)
      }, 2000)
    }
  })

  // Maybe they were quick and changed to dark mode
  // while we were showing or waiting to show the popup.
  $: if ($darkMode) {
    // Prevent the popup from appearing.
    clearTimeout(popupTimeout)

    // Close the popup if it is open.
    active = false

    // Save state to it won't appear on subsequent visits.
    localStorage.setItem('hideDarkModePopup', 'true')
  }
</script>

<Snackbar
  bind:active
  class="primary-color"
  top
  right
  offsetY="{offsetY + 8}px"
  style="min-width: 0"
  transition={popupFadeOut}
>
  <span class="mr-2">Try dark mode!</span>
  <Icon style="color: inherit" path={mdiChevronDoubleUp} />
</Snackbar>
