// @ts-check

import react from "@astrojs/react";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "astro/config";

// https://astro.build/config
export default defineConfig({
	integrations: [react()],
	site: process.env.SITE_URL || "http://localhost:4322",

	vite: {
		plugins: [tailwindcss()],
		define: {
			"import.meta.env.PUBLIC_API_URL": JSON.stringify(
				process.env.PUBLIC_API_URL || "/api/v1",
			),
		},
		server: {
			proxy: {
				"/api": {
					target: "http://localhost:5000",
					changeOrigin: true,
				},
			},
		},
	},
});
