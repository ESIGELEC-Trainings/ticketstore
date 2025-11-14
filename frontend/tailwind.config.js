/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        'neon-purple': '#a855f7',
        'neon-violet': '#8b5cf6',
        'neon-pink': '#ec4899',
        'dark-bg': '#0a0a0f',
        'dark-card': '#1a1a2e',
      },
      boxShadow: {
        'neon': '0 0 20px rgba(168, 85, 247, 0.5)',
        'neon-strong': '0 0 40px rgba(168, 85, 247, 0.8)',
      },
      animation: {
        'glow': 'glow 2s ease-in-out infinite alternate',
      },
      keyframes: {
        glow: {
          '0%': { boxShadow: '0 0 20px rgba(168, 85, 247, 0.5)' },
          '100%': { boxShadow: '0 0 40px rgba(168, 85, 247, 0.8)' },
        }
      }
    },
  },
  plugins: [],
}
