// For testing. Used to transform Javascript code when importing modules as source code.
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
  ],
}
