<script>
  import { fade, slide, crossfade } from "svelte/transition";
  import {
    selectedOption,
    isDataHovered,
    hoveredData,
    clickedYear,
    hoveredDataYear,
    includeKeywordsParantheses,
    drawerState,
  } from "../../../stores";
  import YearsSongList from "../details/YearsSongList.svelte";
  import DecadeSelector from "../details/DecadeSelector.svelte";
  import AudioPlay from "$lib/components/AudioPlay.svelte";
  import { insight } from "../../../utils/insight.js";
  import RenderCommentary from "./RenderCommentary.svelte";

  export let showingData;
  export let screenWidth;
  export let isMobile;

  $: selectedInsight = insight.find((d) => d.type === $selectedOption);

  let showingSongList = false;
  let activeTab = "words";

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
  {#if !isMobile || $drawerState !== "closed"}
    <div class="tabs" transition:crossfade>
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
  {/if}

  {#if activeTab === "songs"}
    <DecadeSelector {showingData} {scrollToYear} />
  {/if}
</div>

{#if !isMobile || $drawerState !== "closed"}
  <div class="content">
    {#if activeTab === "words"}
      <RenderCommentary {selectedInsight} />
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
{/if}

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
