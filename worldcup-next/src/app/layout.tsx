import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "World Cup 2026 | Live Dashboard",
  description: "Real-time World Cup 2026 dashboard with live betting odds",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="bg-background text-primary min-h-screen">{children}</body>
    </html>
  );
}
