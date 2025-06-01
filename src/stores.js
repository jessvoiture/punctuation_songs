import { writable, readable } from "svelte/store";

export const selectedOption = writable("parentheses");
export const hoveredData = writable(undefined);
export const hoveredDataYear = writable(undefined);
export const mouseX = writable(undefined);
export const mouseY = writable(undefined);
export const isDataHovered = writable(false);
export const clickedYear = writable(undefined);
export const isDrawerExpanded = writable(false);
