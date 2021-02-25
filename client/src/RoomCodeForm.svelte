<script lang="ts">
  import { Button, TextField, Row, Col, Icon } from 'svelte-materialify'
  import { createEventDispatcher } from 'svelte'
  import { mdiAccountSwitch, mdiCancel } from '@mdi/js'

  let value = ''

  const counter = 4

  const rules: ((value: string) => true | string)[] = [
    (value) => value.length === counter || `Code must be ${counter} characters`,
  ]

  const dispatch = createEventDispatcher()
</script>

<Row>
  <Col>
    <TextField bind:value {counter} {rules} validateOnBlur>Room Code</TextField>
  </Col>
</Row>
<Row class="mt-8">
  <Col>
    <Button
      type="reset"
      class="error-color"
      block
      tile
      on:click={() => dispatch('cancel')}
    >
      <Icon path={mdiCancel} />
      <div class="flex-grow-1">Cancel</div>
    </Button>
  </Col>
</Row>
<Row>
  <Col>
    <Button
      type="submit"
      class="primary-color"
      block
      tile
      disabled={value.length != 4}
    >
      <Icon path={mdiAccountSwitch} />
      <div class="flex-grow-1">Join Game</div>
    </Button>
  </Col>
</Row>
