import { writable, readable } from "svelte/store";

export const selectedOption = writable("parentheses");
export const selectedMetric = writable("Percent");

export const hoveredData = writable(undefined);
export const hoveredDataYear = writable(undefined);
export const mouseX = writable(undefined);
export const mouseY = writable(undefined);
export const isDataHovered = writable(false);

export const clickedYear = writable(undefined);

export const isDrawerExpanded = writable(false);

export const includeKeywordsParantheses = writable(false);

export const currentAudio = writable(null);

export const isPlaying = writable(false);
export const activeController = writable(null);
export const activeUri = writable(null);

// ...existing code...
export const spotifyCurrentTrack = writable(null); // newly added
