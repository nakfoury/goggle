// For testing.
// See: https://timdeschryver.dev/blog/how-to-test-svelte-components
module.exports = {
  presets: [
    [
      '@babel/preset-env',
      {
        targets: {
          node: 'current',
        },
      },
    ],
    '@babel/preset-typescript',
  ],
}
