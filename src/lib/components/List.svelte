<script>
  import { fade, slide } from "svelte/transition";
  import {
    selectedOption,
    isDataHovered,
    hoveredData,
    clickedYear,
    hoveredDataYear,
  } from "../../stores";
  import YearsSongList from "./YearsSongList.svelte";

  export let data;

  let showingSongList = false;
  let buttonText = "Show songs";

  let showingData = data.find((d) => d.type === "parantheses")?.years || [];
  $: showingData = data.find((d) => d.type === $selectedOption)?.years || [];

  $: buttonText = showingSongList ? "Hide songs" : "Show songs";

  $: clickedYear.subscribe((year) => {
    if (year) {
      scrollToYear(year);
    }
  });

  function toggleSongList() {
    showingSongList = !showingSongList;
  }

  function scrollToYear(year) {
    showingSongList = true;

    setTimeout(() => {
      const element = document.getElementById(`year-${year}`);
      if (element) {
        element.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    }, 500);
  }
</script>

<div class="details-wrapper">
  <div class="details">
    <!-- this is for intelligent insight and the expand song list button -->
    <div class="details-header">
      <div id="commentary" class="body-text">Intelligent insight.</div>

      <button on:click={toggleSongList} class="toggle-button">
        {buttonText}
        <i class="material-icons chevron" class:opened={showingSongList}>
          keyboard_arrow_down
        </i>
      </button>
    </div>

    <!-- this is the song list -->
    <!-- if clause is inside so that div takes up space -->
    <div class="song-list-wrapper">
      {#if showingSongList}
        <div class="body-text list" transition:fade>
          <!-- for each year -->
          {#each showingData as year}
            <YearsSongList {year} />
          {/each}
        </div>
      {/if}
    </div>
  </div>
</div>

<style>
  .details-wrapper {
    overflow-y: auto;
    font-family: sans-serif;
    font-size: 14px;
    display: flex;
    flex-direction: column;
    align-content: flex-start;
    justify-content: flex-start;
    align-items: flex-start;
    height: 100%;
    flex-grow: 1;
    overflow: hidden;
  }

  .details-header {
    position: sticky;
    top: 0;
    padding-bottom: 16px;
    background-color: #fff;
    font-size: 16px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding-right: 80px;
  }

  .details {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  .song-list-wrapper {
    margin-bottom: 48px;
    overflow-y: auto;
    max-height: 100%;
    padding-right: 40px;
  }

  .list {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }

  .toggle-button {
    background: none;
    border: none;
    font-size: 14px;
    font-family: sans-serif;
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    gap: 4px;
    padding: 4px 8px;
    border-radius: 8px;
    justify-content: space-between;
    width: 120px;
  }

  .toggle-button:hover {
    background-color: #f6f6f6;
  }

  .chevron {
    font-size: 16px;
    color: inherit;
    background: none;
    border: none;
    transition: transform 0.5s ease;
  }

  .opened {
    transform: rotate(-180deg);
  }
</style>
