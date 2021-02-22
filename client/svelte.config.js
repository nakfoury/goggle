// For testing; allows <script lang="ts"> Svelte components to be parsable.
// See: https://daveceddia.com/svelte-typescript-jest/
const sveltePreprocess = require('svelte-preprocess')

module.exports = {
  preprocess: sveltePreprocess(),
}
