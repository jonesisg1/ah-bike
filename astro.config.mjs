import { defineConfig } from 'astro/config';
import tailwind from "@astrojs/tailwind";
import htmx from 'astro-htmx';
// import vercel from '@astrojs/vercel/static';
import vercel from '@astrojs/vercel/serverless';

// https://astro.build/config
export default defineConfig({
  integrations: [tailwind(), htmx()],
  output: 'hybrid',
  // output: 'server',
  adapter: vercel({
    webAnalytics: {
      enabled: true,
    },
    maxDuration: 8,
  }),
});
