// For testing.
// See: https://timdeschryver.dev/blog/how-to-test-svelte-components
module.exports = {
  transform: {
    '^.+\\.svelte$': 'svelte-jester',
    '^.+\\.(js|ts)$': 'babel-jest',
  },
  moduleFileExtensions: ['js', 'ts', 'svelte'],
}
