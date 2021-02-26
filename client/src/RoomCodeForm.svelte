<script lang="ts">
  import { Button, TextField, Row, Col, Icon } from 'svelte-materialify/src'
  import { createEventDispatcher } from 'svelte'
  import { mdiAccountSwitch, mdiCancel } from '@mdi/js'

  let value = ''

  const counter = 4

  // Input validation rules.
  const rules: ((value: string) => true | string)[] = [
    (value) => value.length === counter || `Code must be ${counter} letters`,
    (value) => /^[A-Za-z]+$/.test(value) || `Code has illegal characters`,
  ]

  const dispatch = createEventDispatcher()

  // Bind whether the input is valid.
  let error = false

  // Control whether to disable the buttons.
  $: disabled = error || !value.length
</script>

<!-- Text input for the room code -->

<Row>
  <Col>
    <TextField bind:value bind:error {counter} {rules}>Room Code</TextField>
  </Col>
</Row>

<!-- Cancel button -->

<Row class="mt-8">
  <Col>
    <Button class="error-color" block tile on:click={() => dispatch('cancel')}>
      <Icon path={mdiCancel} />
      <div class="flex-grow-1">Cancel</div>
    </Button>
  </Col>
</Row>

<!-- Join Game button -->

<Row>
  <Col>
    <Button
      class={disabled ? undefined : 'primary-color'}
      block
      tile
      {disabled}
    >
      <Icon path={mdiAccountSwitch} />
      <div class="flex-grow-1">Join Game</div>
    </Button>
  </Col>
</Row>
