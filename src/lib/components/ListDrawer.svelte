<script>
  import { tweened } from "svelte/motion";
  import { cubicOut } from "svelte/easing";

  import List from "./List.svelte";
  import YearsSongList from "./YearsSongList.svelte";
  import { selectedOption } from "../../stores";

  export let data;
  export let screenHeight;

  let expandedHeight = screenHeight * 0.95;
  let collapsedHeight = 40;

  let showingData = data.find((d) => d.type === "parantheses")?.years || [];
  $: showingData = data.find((d) => d.type === $selectedOption)?.years || [];

  $: expandedHeight = screenHeight * 0.95;

  let isExpanded = false;
  let drawerHeight = tweened(collapsedHeight, {
    duration: 300,
    easing: cubicOut,
  });

  function toggleDrawer() {
    isExpanded = !isExpanded;
    drawerHeight.set(isExpanded ? expandedHeight : collapsedHeight);
  }
</script>

<div class="drawer" style="height: {$drawerHeight}px;">
  <button
    class="drawer-toggle"
    on:click={toggleDrawer}
    aria-expanded={isExpanded}
  >
    <span class="drawer-label"
      >{isExpanded ? "Hide Details" : "Show Details"}</span
    >
    <i class="material-icons toggle-icon" class:expanded={isExpanded}>
      expand_less
    </i>
  </button>

  {#if isExpanded}
    <div class="drawer-content">
      {#each showingData as year}
        <YearsSongList {year} />
      {/each}
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
    overflow: hidden;
    transition: height 0.3s ease;
    border-top: 1px solid #ddd;
    font-family: sans-serif;
  }

  .drawer-label {
    font-size: 16px;
    font-weight: bold;
  }
  .drawer-content {
    padding: 20px;
    overflow-y: auto;
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
    padding: 10px 20px;
    cursor: pointer;
  }
</style>
