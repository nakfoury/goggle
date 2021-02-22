import App from './App.svelte'
import { render } from '@testing-library/svelte'
import '@testing-library/jest-dom/extend-expect'

describe('App', () => {
  it('should render', () => {
    const app = render(App)
    expect(app.getByText('Create Game')).toBeInTheDocument()
  })
})
