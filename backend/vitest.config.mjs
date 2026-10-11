import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    globals: true,
    coverage: {
      include: ['src/**/*.js'],
      // The Supabase adapter and the process entry point need a live database / process.
      exclude: ['src/repositories/supabase.js', 'src/server.js'],
      thresholds: { lines: 85 },
    },
  },
});
