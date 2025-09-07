<script>
  import { fade, slide } from "svelte/transition";
  import {
    selectedOption,
    isDataHovered,
    hoveredData,
    clickedYear,
    hoveredDataYear,
    includeKeywordsParantheses,
  } from "../../../stores";
  import YearsSongList from "../details/YearsSongList.svelte";
  import { insight } from "../../../utils/insight.js";

  export let showingData;
  export let screenWidth;

  console.log(showingData);

  $: selectedInsight = insight.find((d) => d.type === $selectedOption);

  let showingSongList = false;
  let buttonText = "Show songs";
  let activeTab = "words";

  $: buttonText = showingSongList ? "Hide songs" : "Show songs";

  $: clickedYear.subscribe((year) => {
    if (year) {
      scrollToYear(year);
    }
  });

  function toggleSongList() {
    activeTab = "songs";

    if (showingSongList) {
      scrollToYear(1958);
    }
  }

  function scrollToYear(year) {
    activeTab = "songs";

    setTimeout(() => {
      const element = document.getElementById(`year-${year}`);
      if (element) {
        element.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    }, 500);
  }
</script>

<!-- svelte-ignore a11y_no_static_element_interactions -->
<!-- svelte-ignore a11y_click_events_have_key_events -->
<div class="tabs-wrapper">
  <div class="tabs">
    <div
      class="tab {activeTab === 'words' ? 'active' : ''}"
      on:click={() => (activeTab = "words")}
    >
      Words
    </div>

    <div
      class="tab {activeTab === 'songs' ? 'active' : ''}"
      on:click={() => (activeTab = "songs")}
    >
      Songs
    </div>
  </div>

  {#if activeTab === "songs"}
    <div class="decade-selector">
      <button class="toggle-button" on:click={toggleSongList}> test </button>
    </div>
  {/if}
</div>

<div class="content">
  {#if activeTab === "words"}
    <div id="commentary" class="body-text">
      {@html selectedInsight.copy}
    </div>
  {:else if activeTab === "songs"}
    <div class="song-list-wrapper">
      <div class="body-text list" transition:fade>
        {#each showingData as year}
          <YearsSongList {year} {screenWidth} />
        {/each}
      </div>
    </div>
  {/if}
</div>

<style>
  .song-list-wrapper {
    flex-grow: 1;
    margin-bottom: 48px;
  }

  .list {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }

  #commentary {
    color: #636363;
    font-size: 14px;
    line-height: 125%;
  }

  .content {
    padding-bottom: 48px;
  }

  .tabs-wrapper {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1rem;
    position: sticky;
    top: 0;
    background-color: #fff;
    display: flex;
    flex-direction: column;
  }

  .tabs {
    display: flex;
    flex-direction: row;
  }

  .tab {
    padding: 8px 12px;
    cursor: pointer;
    border-bottom: 2px solid #fff;
    border-radius: 8px 8px 0px 0px;
    font-size: 16px;
  }
  .tab.active {
    border-bottom: 4px solid #ddd;
  }

  .tab:hover {
    background-color: #f6f6f6;
  }

  .decade-selector {
    padding-bottom: 8px;
  }
</style>
