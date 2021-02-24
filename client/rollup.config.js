import svelte from 'rollup-plugin-svelte-hot'
import commonjs from '@rollup/plugin-commonjs'
import resolve from '@rollup/plugin-node-resolve'
import { terser } from 'rollup-plugin-terser'
import typescript from '@rollup/plugin-typescript'
import hmr from 'rollup-plugin-hot'
import del from 'rollup-plugin-delete'
import replace from '@rollup/plugin-replace'

const { preprocess } = require('./svelte.config')

const production = !process.env.ROLLUP_WATCH
const prodAPI = production || !!process.env.PROD_API

export default {
  input: 'src/main.ts',
  output: {
    sourcemap: !production,
    format: 'iife',
    name: 'app',
    file: 'public/build/bundle.js',
  },
  plugins: [
    svelte({
      preprocess,
      // enable run-time checks when not in production
      dev: !production,
      // we'll extract any component CSS out into
      // a separate file - better for performance
      // NOTE when hot option is enabled, a blank file will be written to
      // avoid CSS rules conflicting with HMR injected ones
      css: (css) => {
        css.write(process.env.NOLLUP ? 'build/bundle.css' : 'bundle.css')
      },
      hot: !production && {
        // Optimistic will try to recover from runtime
        // errors during component init
        optimistic: true,
        // See docs of rollup-plugin-svelte-hot for all available options:
        // https://github.com/rixo/rollup-plugin-svelte-hot#usage
      },
    }),

    // If you have external dependencies installed from
    // npm, you'll most likely need these plugins. In
    // some cases you'll need additional configuration -
    // consult the documentation for details:
    // https://github.com/rollup/plugins/tree/master/packages/commonjs
    resolve({
      browser: true,
      dedupe: ['svelte'],
    }),
    commonjs(),
    typescript({
      sourceMap: !production,
      inlineSources: !production,
    }),

    // If we're building for production (npm run build
    // instead of npm run dev), minify
    production && terser(),

    hmr({
      public: 'public',
      inMemory: true,

      // Default host for the HMR server is localhost, change this option if
      // you want to serve over the network
      // host: '0.0.0.0',
      // You can also change the default HMR server port, if you fancy
      // port: '12345'

      // This is needed, otherwise Terser (in npm run build) chokes
      // on import.meta. With this option, the plugin will replace
      // import.meta.hot in your code with module.hot, and will do
      // nothing else.
      compatModuleHot: production,
    }),

    // Clear the build directory before building.
    // Useful for clearing out source maps before creating a production build.
    production && del({ targets: 'public/build' }),

    // Replace local backend server addresses with production addresses when
    // creating a production build.
    prodAPI &&
      replace({
        'http://localhost:8081': 'https://api.freewordgame.com',
        'ws://localhost:8082': 'wss://ws.freewordgame.com',
      }),
  ],
  watch: {
    clearScreen: false,
  },
}
