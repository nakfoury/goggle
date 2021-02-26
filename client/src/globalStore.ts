import { writable } from 'svelte/store'

// Create a store for saving the last-entered user name in local storage
// for subsequent visits.

export const name = writable(localStorage.getItem('name') ?? '')

name.subscribe((value) => {
  localStorage.setItem('name', value)
})

// Create a store for saving the user's dark mode setting,
// for setting the theme on subsequent visits.

export const darkMode = writable(localStorage.getItem('darkMode') === 'true')

darkMode.subscribe((value) => {
  if (value) {
    localStorage.setItem('darkMode', 'true')
  } else {
    localStorage.setItem('darkMode', 'false')
  }
})
