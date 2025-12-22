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

  const pos = spring(closed, {
    stiffness: 0.1,
    damping: 0.5,
  });

  $: drawerHeight.set($pos);

  $: {
    const h = $pos;
    if (h >= full - 10) drawerState.set("open");
    else if (h <= closed + 10) drawerState.set("closed");
    else drawerState.set("partial");
  }

  export function openHalf() {
    pos.set(half);
  }
  export function openFull() {
    pos.set(full);
  }
  export function closeDrawer() {
    pos.set(closed);
  }

  let dragging = false;
  let startY = 0;
  let startPos = 0;

  let lastY = 0;
  let lastTime = 0;
  let velocity = 0;

  function handlePointerDown(e) {
    dragging = true;

    startY = lastY = e.clientY;
    startPos = $pos;

    lastTime = performance.now();
    velocity = 0;

    document.addEventListener("pointermove", handlePointerMove);
    document.addEventListener("pointerup", handlePointerUp);
  }

  function handlePointerMove(e) {
    if (!dragging) return;

    const now = performance.now();
    const y = e.clientY;

    const dy = y - startY;
    const next = startPos - dy;

    const dt = now - lastTime;
    if (dt > 0) velocity = (y - lastY) / dt;

    lastY = y;
    lastTime = now;

    const clamped = Math.min(full, Math.max(closed, next));
    pos.set(clamped, { hard: true });
  }

  function handlePointerUp() {
    dragging = false;

    const h = $pos;
    const speed = velocity;

    const FAST = 0.8; // strong flick
    const MED = 0.1; // light flick

    const state = currentSnap(h);

    // -------- FULL --------
    if (state === "full") {
      if (speed > FAST)
        pos.set(closed); // fast down → close
      else if (speed > MED)
        pos.set(half); // soft down → half
      else pos.set(full);
    }

    // -------- CLOSED --------
    else if (state === "closed") {
      if (speed < -FAST)
        pos.set(full); // fast up → open
      else if (speed < -MED)
        pos.set(half); // soft up → half
      else pos.set(closed);
    }

    // -------- HALF --------
    else {
      if (speed < -FAST) pos.set(full);
      else if (speed > FAST) pos.set(closed);
      else {
        const fullThreshold = (full + half) / 2;
        const halfThreshold = (half + closed) / 2;

        if (h > fullThreshold) pos.set(full);
        else if (h < halfThreshold) pos.set(closed);
        else pos.set(half);
      }
    }

    document.removeEventListener("pointermove", handlePointerMove);
    document.removeEventListener("pointerup", handlePointerUp);
  }

  function currentSnap(pos) {
    if (pos >= (full + half) / 2) return "full";
    if (pos <= (half + closed) / 2) return "closed";
    return "half";
  }
</script>

<div class="drawer" style="height: {$pos}px;">
  <div class="handle" on:pointerdown={handlePointerDown}>
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
    <List {showingData} {screenWidth} {isMobile} />
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
    box-shadow: 0 -1px 5px rgba(0, 0, 0, 0.1);
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
    padding: 20px 0 20px 0;
    display: flex;
    justify-content: center;
    cursor: grab;
    touch-action: none;
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
    padding: 0px 28px 8px 28px;
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
