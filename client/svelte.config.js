// For testing; allows <script lang="ts"> Svelte components to be parsable.
// See: https://daveceddia.com/svelte-typescript-jest/
const sveltePreprocess = require('svelte-preprocess')

function createPreprocessors() {
  return sveltePreprocess({
    // Needed by svelte-materialify.
    scss: {
      includePaths: ['theme'],
    },
  })
}

module.exports = {
  preprocess: createPreprocessors(),
  createPreprocessors,
}
