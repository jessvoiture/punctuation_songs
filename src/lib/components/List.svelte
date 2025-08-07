<script>
  import { fade, slide } from "svelte/transition";
  import {
    selectedOption,
    isDataHovered,
    hoveredData,
    clickedYear,
    hoveredDataYear,
    includeKeywordsParantheses,
  } from "../../stores";
  import YearsSongList from "./YearsSongList.svelte";
  import { insight } from "../../utils/insight.js";

  export let showingData;
  export let screenWidth;

  $: selectedInsight = insight.find((d) => d.type === $selectedOption);

  let showingSongList = false;
  let buttonText = "Show songs";

  $: buttonText = showingSongList ? "Hide songs" : "Show songs";

  $: clickedYear.subscribe((year) => {
    if (year) {
      scrollToYear(year);
    }
  });

  function toggleSongList() {
    showingSongList = !showingSongList;

    if (showingSongList) {
      scrollToYear(1958);
    }
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
  <div id="commentary" class="body-text">
    {@html selectedInsight.copy}
  </div>

  <div class="button-wrapper">
    <button on:click={toggleSongList} class="toggle-button">
      {buttonText}
      <i class="material-icons chevron" class:opened={showingSongList}>
        keyboard_arrow_down
      </i>
    </button>
  </div>

  <div class="song-list-wrapper">
    {#if showingSongList}
      <div class="body-text list" transition:fade>
        {#each showingData as year}
          <YearsSongList {year} {screenWidth} />
        {/each}
      </div>
    {/if}
  </div>
</div>

<style>
  .details-wrapper {
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow: auto;
    font-family: sans-serif;
    font-size: 16px;
    line-height: 20px;
    padding-right: 40px;
  }

  .song-list-wrapper {
    flex-grow: 1;
    margin-bottom: 48px;
  }

  .list {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }

  .button-wrapper {
    width: 100%;
    position: sticky;
    top: 0;
    background-color: white;
    z-index: 10;
    padding: 16px 0px;
  }

  .toggle-button {
    background: none;
    border: none;
    font-size: 16px;
    line-height: 20px;
    font-family: sans-serif;
    display: flex;
    align-items: center;
    gap: 4px;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 8px;
  }

  .toggle-button:hover {
    background-color: #f6f6f6;
  }

  .chevron {
    font-size: 16px;
    color: inherit;
    transition: transform 0.5s ease;
  }

  .opened {
    transform: rotate(-180deg);
  }

  #commentary {
    color: #636363;
  }
</style>
