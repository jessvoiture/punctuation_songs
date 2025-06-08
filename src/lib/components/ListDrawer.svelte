<script>
  import { tweened } from "svelte/motion";
  import { cubicOut } from "svelte/easing";
  import { fade } from "svelte/transition";

  import List from "./List.svelte";
  import YearsSongList from "./YearsSongList.svelte";
  import ParenthesesToggle from "./ParenthesesToggle.svelte";
  import { selectedOption, clickedYear } from "../../stores";

  export let screenHeight;
  export let showingData;

  let expandedHeight = screenHeight * 0.95;
  let collapsedHeight = 50;

  $: expandedHeight = screenHeight * 0.95;

  let isDrawerExpanded = false;
  let drawerHeight = tweened(collapsedHeight, {
    duration: 300,
    easing: cubicOut,
  });

  function toggleDrawer() {
    isDrawerExpanded = !isDrawerExpanded;
    drawerHeight.set(isDrawerExpanded ? expandedHeight : collapsedHeight);
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
</script>

{#if isDrawerExpanded}
  <div class="overlay" transition:fade></div>
{/if}

<div class="drawer" style="height: {$drawerHeight}px;">
  <button
    class="drawer-toggle"
    on:click={toggleDrawer}
    aria-expanded={isDrawerExpanded}
  >
    <span class="drawer-label"
      >{isDrawerExpanded ? "Hide Details" : "Show Details"}</span
    >
    <i class="material-icons toggle-icon" class:expanded={isDrawerExpanded}>
      expand_less
    </i>
  </button>

  {#if isDrawerExpanded}
    <div class="drawer-content">
      <div class="song-list-wrapper">
        {#each showingData as year}
          <YearsSongList {year} />
        {/each}
      </div>
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

  .drawer-content {
    padding: 8px 20px 20px 20px;
    overflow-y: auto;
    max-height: calc(95vh - 60px);
    display: flex;
    flex-direction: column;
    gap: 24px;
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
    padding: 15px 20px;
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

  .song-list-wrapper {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }
</style>
