<script>
  import { tweened } from "svelte/motion";
  import { cubicOut } from "svelte/easing";
  import { fade } from "svelte/transition";

  import List from "./List.svelte";
  import YearsSongList from "./YearsSongList.svelte";
  import ParenthesesToggle from "../ParenthesesToggle.svelte";
  import { insight } from "../../../utils/insight.js";
  import { selectedOption, clickedYear, drawerState } from "../../../stores";

  export let screenHeight;
  export let showingData;
  export let screenWidth;

  let expandedHeight = screenHeight * 0.95;
  let middleHeight = screenHeight * 0.4;
  let collapsedHeight = 50;

  $: selectedInsight = insight.find((d) => d.type === $selectedOption);
  $: expandedHeight = screenHeight * 0.95;
  $: middleHeight = screenHeight * 0.4;

  let isDrawerExpanded = false;

  let drawerHeight = tweened(collapsedHeight, {
    duration: 200,
    easing: cubicOut,
  });

  function fullyOpenDrawer() {
    isDrawerExpanded = true;
    drawerHeight.set(expandedHeight);
    drawerState.set("open");
  }

  function fullyCloseDrawer() {
    isDrawerExpanded = false;
    drawerHeight.set(collapsedHeight);
    drawerState.set("closed");
  }

  function paritallyOpenDrawer() {
    isDrawerExpanded = false;
    drawerHeight.set(middleHeight);
    drawerState.set("middle");
  }

  $: clickedYear.subscribe((year) => {
    if (year) {
      scrollToYear(year);
    }
  });

  function scrollToYear(year) {
    toggleDrawer();

    setTimeout(() => {
      const element = document.getElementById(`year-${year}`);
      if (element) {
        element.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    }, 500);
  }

  const buttonConfigs = {
    open: [
      { icon: "expand_less", action: paritallyOpenDrawer },
      { icon: "keyboard_double_arrow_down", action: fullyCloseDrawer },
    ],
    middle: [
      { icon: "expand_more", action: fullyCloseDrawer },
      { icon: "expand_less", action: fullyOpenDrawer },
    ],
    closed: [
      { icon: "expand_less", action: paritallyOpenDrawer },
      { icon: "keyboard_double_arrow_up", action: fullyOpenDrawer },
    ],
  };
</script>

{#if $drawerState === "open"}
  <div class="overlay" transition:fade></div>
{/if}

<div class="drawer" style="height: {$drawerHeight}px;">
  <div class="drawer-actions">
    {#each buttonConfigs[$drawerState] as btn}
      <button class="drawer-toggle" on:click={btn.action}>
        <i class="material-icons toggle-icon">{btn.icon}</i>
      </button>
    {/each}
  </div>

  {#if isDrawerExpanded}
    <div class="drawer-content">
      <List {showingData} {screenWidth} />
    </div>
  {/if}
</div>

<style>
  .drawer {
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
    background-color: #fff;
    box-shadow: 0 -4px 8px rgba(0, 0, 0, 0.1);
    transition: height 0.3s ease;
    border-top: 1px solid #ddd;
    font-family: sans-serif;
    z-index: 10000;
  }

  .drawer-actions {
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    border-bottom: 1px solid #ddd;
    background-color: #f9f9f9;
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

  .drawer-label {
    font-size: 16px;
    font-weight: bold;
  }
  .toggle-icon {
    font-size: 20px;
    transform: rotate(0deg);
    transition: transform 0.3s ease;
  }

  .toggle-icon.expanded {
    transform: rotate(180deg);
  }

  button.drawer-toggle {
    background: none;
    border: none;
    font-size: 16px;
    font-family: inherit;
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    padding: 16px 20px;
    cursor: pointer;
  }

  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent black */
    z-index: 10; /* Ensure it sits behind the drawer */
    opacity: 1;
    pointer-events: none; /* Prevent interaction when invisible */
  }
</style>
