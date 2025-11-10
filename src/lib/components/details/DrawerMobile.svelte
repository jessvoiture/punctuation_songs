<script>
  import { spring } from "svelte/motion";
  import { drawerHeight, drawerState } from "../../../stores";

  import List from "./List.svelte";
  import YearsSongList from "./YearsSongList.svelte";
  import ParenthesesToggle from "../ParenthesesToggle.svelte";
  import { insight } from "../../../utils/insight.js";

  export let screenHeight = window.innerHeight;
  export let showingData;
  export let screenWidth;

  let partialRatio = 0.42;
  let fullRatio = 0.95;

  const closed = 75;
  let half = screenHeight * partialRatio;
  let full = screenHeight * fullRatio;

  // main spring for drawer position
  const pos = spring(closed, {
    stiffness: 0.2,
    damping: 0.5,
  });

  // keep global stores synced
  $: drawerHeight.set($pos);

  $: {
    const h = $pos;
    if (h >= full - 10) drawerState.set("open");
    else if (h <= closed + 10) drawerState.set("closed");
    else drawerState.set("partial");
  }

  // this can be called externally through bind:this
  export function openHalf() {
    pos.set(half);
  }
  export function openFull() {
    pos.set(full);
  }
  export function closeDrawer() {
    pos.set(closed);
  }

  // dragging logic
  let dragging = false;
  let startY = 0;
  let startPos = 0;

  function handlePointerDown(e) {
    dragging = true;
    startY = e.clientY;
    startPos = $pos;

    document.addEventListener("pointermove", handlePointerMove);
    document.addEventListener("pointerup", handlePointerUp);
  }

  function handlePointerMove(e) {
    if (!dragging) return;

    const dy = e.clientY - startY;
    const next = startPos - dy;

    const clamped = Math.min(full, Math.max(closed, next));
    pos.set(clamped, { hard: true });
  }

  function handlePointerUp() {
    dragging = false;
    const h = $pos;

    const fullThreshold = (full + half) / 2;
    const halfThreshold = (half + closed) / 2;

    if (h > fullThreshold) pos.set(full);
    else if (h < halfThreshold) pos.set(closed);
    else pos.set(half);

    document.removeEventListener("pointermove", handlePointerMove);
    document.removeEventListener("pointerup", handlePointerUp);
  }
</script>

<div class="drawer" style="height: {$pos}px;">
  <div class="handle" on:pointerdown={handlePointerDown}>
    <div class="handle-bar"></div>
  </div>

  <div class="drawer-content">
    <List {showingData} {screenWidth} />
  </div>
</div>

<style>
  .drawer {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    background: #fff;
    border-radius: 20px 20px 0 0;
    box-shadow: 0 -4px 5px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    touch-action: none;
  }

  .drawer-content {
    padding-right: 16px;
    padding-left: 16px;
    overflow-y: auto;
    max-height: calc(95vh - 60px);
    display: flex;
    flex-direction: column;
    gap: 0px;
    background-color: #fff;
  }

  .handle {
    width: 100%;
    padding: 12px 0 12px 0;
    display: flex;
    justify-content: center;
    cursor: grab;
  }

  .handle-bar {
    width: 40px;
    height: 5px;
    background: #ccc;
    border-radius: 999px;
  }
</style>
