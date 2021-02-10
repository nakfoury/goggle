import App from './App.svelte'
import { render } from '@testing-library/svelte'
import '@testing-library/jest-dom/extend-expect'

describe('App', () => {
  it('should render', () => {
    const { getByText } = render(App)
    expect(getByText('Free games take time.')).toBeInTheDocument()
  })
})
