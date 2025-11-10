import { writable, readable } from "svelte/store";

export const selectedOption = writable("parentheses");
export const selectedMetric = writable("Percent");
export const includeKeywordsParantheses = writable(false);

export const hoveredData = writable(undefined);
export const hoveredDataYear = writable(undefined);
export const mouseX = writable(undefined);
export const mouseY = writable(undefined);
export const isDataHovered = writable(false);

export const clickedYear = writable(undefined);

export const currentAudio = writable(null);
export const isPlaying = writable(false);

export const isDrawerExpanded = writable(false);
export const drawerState = writable("closed");
export const drawerHeight = writable(0);
