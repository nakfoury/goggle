<script lang="ts">
  import { Button, MaterialApp, AppBar, Icon } from 'svelte-materialify'
  import { mdiWeatherNight, mdiWeatherSunny } from '@mdi/js'
  import NameForm from './NameForm.svelte'

  let darkMode = !!localStorage.getItem('darkMode')

  function toggleDarkMode() {
    darkMode = !darkMode
    if (darkMode) {
      localStorage.setItem('darkMode', 'true')
    } else {
      localStorage.removeItem('darkMode')
    }
  }
</script>

<MaterialApp theme={darkMode ? 'dark' : 'light'}>
  <AppBar>
    <span slot="title">Goggle</span>
    <div class="flex-grow-1" />
    <Button fab text on:click={toggleDarkMode}>
      <Icon path={darkMode ? mdiWeatherSunny : mdiWeatherNight} />
    </Button>
  </AppBar>
  <NameForm />
</MaterialApp>
