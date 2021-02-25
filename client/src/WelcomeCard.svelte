<script lang="ts">
  import { Card, Container, Row, Col } from 'svelte-materialify'
  import { fly } from 'svelte/transition'
  import NameForm from './NameForm.svelte'
  import RoomCodeForm from './RoomCodeForm.svelte'

  let page = 'nameForm'
</script>

<Container class="mt-sm-16">
  <Row>
    <Col sm={6} offset_sm={3} lg={4} offset_lg={4}>
      <Card raised class="pa-8" style="overflow-x: hidden">
        <div class="inner-content-wrapper">
          {#if page === 'nameForm'}
            <div class="inner-content" transition:fly={{ x: -200 }}>
              <NameForm on:join={() => (page = 'roomCodeForm')} />
            </div>
          {:else if page === 'roomCodeForm'}
            <div class="inner-content" transition:fly={{ x: 200 }}>
              <RoomCodeForm on:cancel={() => (page = 'nameForm')} />
            </div>
          {/if}
        </div>
      </Card>
    </Col>
  </Row>
</Container>

<style>
  /* Grid display lets the inner content exist in the same space,
  which makes the transition work. */
  .inner-content-wrapper {
    display: grid;
  }
  .inner-content {
    grid-column: 1/2;
    grid-row: 1/2;
  }
</style>
