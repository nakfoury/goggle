// For testing.
// See: https://timdeschryver.dev/blog/how-to-test-svelte-components
module.exports = {
  transform: {
    '^.+\\.svelte$': ['svelte-jester', { preprocess: true }],
    '^.+\\.js$': 'babel-jest',
    '^.+\\.ts$': 'ts-jest',
  },
  moduleFileExtensions: ['js', 'ts', 'svelte'],
  // In Goggle we import svelte-materialify components as source code,
  // so we need to tell Jest to compile it.
  transformIgnorePatterns: ['node_modules/(?!svelte-materialify).+\\.js$'],
}
