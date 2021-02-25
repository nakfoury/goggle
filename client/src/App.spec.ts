import App from './App.svelte'
import { render } from '@testing-library/svelte'
import '@testing-library/jest-dom/extend-expect'

// The Tooltip component uses this function,
// which jest does not implement by default,
// so we mock it.
window.scrollTo = jest.fn()

describe('App', () => {
  it('should render', () => {
    const app = render(App)
    expect(app.getByText('Goggle')).toBeInTheDocument()
  })
})
