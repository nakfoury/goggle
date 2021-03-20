import App from './App.svelte'
import { render } from '@testing-library/svelte'
import '@testing-library/jest-dom/extend-expect'
import 'isomorphic-fetch'

// The Tooltip component uses this function,
// which jest does not implement by default,
// so we mock it.
window.scrollTo = jest.fn()

global.fetch = jest.fn(() => Promise.resolve(new Response()))

describe('App', () => {
  it('should render', () => {
    const app = render(App)
    expect(app.getByText('Goggle')).toBeInTheDocument()
  })
})
