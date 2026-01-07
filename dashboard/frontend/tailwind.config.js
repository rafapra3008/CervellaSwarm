/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        'bg-primary': '#0A1628',
        'bg-secondary': '#111D2E',
        'bg-tertiary': '#152238',
        'accent': { DEFAULT: '#3B82F6', light: '#60A5FA', dark: '#2563EB' },
        'success': '#22C55E',
        'warning': '#F59E0B',
        'error': '#EF4444',
        'working': '#3B82F6',
        'idle': '#475569',
        'text-primary': '#F8FAFC',
        'text-secondary': '#94A3B8',
        'text-muted': '#64748B',
      },
      fontFamily: {
        sans: ['Inter', 'SF Pro Display', '-apple-system', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'SF Mono', 'monospace'],
      },
      borderRadius: { 'sm': '8px', 'md': '12px', 'lg': '16px', 'xl': '24px' },
      boxShadow: { 'card': '0 4px 24px rgba(0, 0, 0, 0.4)', 'glow': '0 0 40px rgba(59, 130, 246, 0.25)' },
    },
  },
  plugins: [],
}
