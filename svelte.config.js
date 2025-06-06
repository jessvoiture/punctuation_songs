import adapter from "@sveltejs/adapter-auto";
import { sveltePreprocess } from "svelte-preprocess";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter(),
  },
  preprocess: sveltePreprocess({
    scss: {
      includePaths: ["src/styles"],
      prependData: `@import 'src/styles/variables.scss';`,
    },
  }),
};

export default config;
