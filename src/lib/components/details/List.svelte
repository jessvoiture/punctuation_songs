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
  import DecadeSelector from "../details/DecadeSelector.svelte";
  import AudioPlayer from "../AudioPlay.svelte";
  import { insight } from "../../../utils/insight.js";

  export let showingData;
  export let screenWidth;

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

<div class="tabs-wrapper">
  <div class="tabs">
    <button
      class="tab {activeTab === 'words' ? 'active' : ''}"
      role="tab"
      aria-selected={activeTab === "words"}
      tabindex={activeTab === "words" ? 0 : -1}
      on:click={() => (activeTab = "words")}
    >
      Words
    </button>

    <button
      class="tab {activeTab === 'songs' ? 'active' : ''}"
      role="tab"
      aria-selected={activeTab === "songs"}
      tabindex={activeTab === "songs" ? 0 : -1}
      on:click={() => (activeTab = "songs")}
    >
      Songs
    </button>
  </div>

  {#if activeTab === "songs"}
    <DecadeSelector {showingData} {scrollToYear} />
  {/if}
</div>

<div class="content">
  {#if activeTab === "words"}
    <div id="commentary" class="body-text">
      {#each selectedInsight.copy as part}
        {#if part.kind === "text"}
          <span>{@html part.value}</span>
        {:else if part.kind === "highlight"}
          <span
            style="background-color:#bee5f3; padding:1px 4px; border-radius:4px; -webkit-box-decoration-break: clone;
    box-decoration-break: clone;"
          >
            {part.value}
          </span>
        {:else if part.kind === "audio"}
          <AudioPlayer src={part.src} song={part.song} />
        {/if}
      {/each}
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
    color: #000000;
    font-size: 15px;
    line-height: 20px;
  }

  .content {
    padding: 8px 0px 48px 0px;
    overflow-y: auto;
    scrollbar-width: none;
  }

  .tabs-wrapper {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 8px;
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
    border: none;
    background-color: #fff;
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
</style>
