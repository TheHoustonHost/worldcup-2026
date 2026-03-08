/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        background: "#000000", card: "#1a1a1a", "card-hover": "#222222",
        border: "#2a2a2a", "border-hover": "#3a3a3a",
        primary: "#ffffff", secondary: "#a1a1a1", tertiary: "#6b6b6b",
        accent: "#3b82f6", "accent-glow": "rgba(59, 130, 246, 0.15)",
      },
      fontFamily: { sans: ["Inter", "sans-serif"], mono: ["JetBrains Mono", "monospace"] },
    },
  },
  plugins: [],
};
