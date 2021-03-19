import type { SvelteComponent } from 'svelte'

// Declare components for which the svelte-materialify library does not declare its own typings.
declare module 'svelte-materialify/src' {
  class Chip extends SvelteComponent {}
  class Subheader extends SvelteComponent {}
  class Table extends SvelteComponent {}
}
