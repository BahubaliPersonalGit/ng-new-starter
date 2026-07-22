import { defineConfig } from 'vitest/config';

export default defineConfig({
    test: {
        coverage: {
            provider: 'v8',
            reporter: ['text', 'html', 'json-summary'],
            thresholds: {
                statements: 70,
                branches: 80,
                functions: 75,
                lines: 80
            }
        }
    }
});