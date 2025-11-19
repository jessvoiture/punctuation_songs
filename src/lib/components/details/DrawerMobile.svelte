<script>
  import { spring } from "svelte/motion";
  import { drawerHeight, drawerState } from "../../../stores";
  import { slide, fade, crossfade } from "svelte/transition";

  import List from "./List.svelte";
  import YearsSongList from "./YearsSongList.svelte";
  import ParenthesesToggle from "../ParenthesesToggle.svelte";
  import { insight } from "../../../utils/insight.js";

  export let screenHeight = window.innerHeight;
  export let showingData;
  export let screenWidth;
  export let isMobile;

  let partialRatio = 0.42;
  let fullRatio = 0.95;

  const closed = 60;
  let half = screenHeight * partialRatio;
  let full = screenHeight * fullRatio;

  // main spring for drawer position
  const pos = spring(closed, {
    stiffness: 0.1,
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

  function handleTouchStart(e) {
    if (e.touches.length !== 1) return;
    dragging = true;
    startY = e.touches[0].clientY;
    startPos = $pos;

    document.addEventListener("touchmove", handleTouchMove, { passive: false });
    document.addEventListener("touchend", handleTouchEnd);
  }

  function handleTouchMove(e) {
    if (!dragging) return;
    e.preventDefault(); // prevent scrolling the page

    const dy = e.touches[0].clientY - startY;
    const next = startPos - dy;
    const clamped = Math.min(full, Math.max(closed, next));
    pos.set(clamped, { hard: true });
  }

  function handleTouchEnd() {
    dragging = false;
    const h = $pos;

    const fullThreshold = (full + half) / 2;
    const halfThreshold = (half + closed) / 2;

    if (h > fullThreshold) pos.set(full);
    else if (h < halfThreshold) pos.set(closed);
    else pos.set(half);

    document.removeEventListener("touchmove", handleTouchMove);
    document.removeEventListener("touchend", handleTouchEnd);
  }
</script>

<div class="drawer" style="height: {$pos}px;">
  <div
    class="handle"
    on:pointerdown={handlePointerDown}
    on:touchstart={handleTouchStart}
  >
    {#if $drawerState !== "closed"}
      <div class="handle-bar"></div>
    {/if}

    {#if $drawerState === "closed"}
      <button id="see_more_button" on:click={openHalf} transition:crossfade>
        See details

        <i class="material-icons">keyboard_arrow_up</i>
      </button>
    {/if}
  </div>

  <div class="drawer-content">
    <List
      {showingData}
      {screenWidth}
      {isMobile}
      {handlePointerDown}
      {handlePointerMove}
      {handlePointerUp}
      {handleTouchStart}
      {handleTouchEnd}
      {handleTouchMove}
      {openHalf}
    />
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

  #see_more_button {
    display: flex;
    width: 100%;
    padding: 8px 28px;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    border: none;
    background-color: #fff;
    border-bottom: 2px solid #fff;
    border-radius: 8px 8px 0px 0px;
    font-size: 16px;
  }
</style>
