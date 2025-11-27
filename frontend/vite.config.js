import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  preview: {
    allowedHosts: ['llm-council-intwriting.up.railway.app'],
  },
  server: {
    allowedHosts: ['llm-council-intwriting.up.railway.app'],
  },
})
