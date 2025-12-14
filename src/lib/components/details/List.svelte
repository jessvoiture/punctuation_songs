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
  import About from "./About.svelte";

  export let showingData;
  export let screenWidth;
  export let isMobile;

  $: selectedInsight = insight.find((d) => d.type === $selectedOption);

  let showingSongList = false;
  let activeTab = "analysis";
  let contentEl;

  $: if (contentEl && activeTab) {
    contentEl.scrollTop = 0;
  }

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
      if (element && contentEl) {
        // Get the element's position relative to the scroll container
        const top = element.offsetTop;
        contentEl.scrollTo({ top: top - 140, behavior: "smooth" });
      }
    }, 500);
  }
</script>

<div class="tabs-wrapper">
  {#if !isMobile || $drawerState !== "closed"}
    <div class="tabs" transition:crossfade>
      <button
        class="tab {activeTab === 'analysis' ? 'active' : ''}"
        role="tab"
        aria-selected={activeTab === "analysis"}
        tabindex={activeTab === "analysis" ? 0 : -1}
        on:click={() => (activeTab = "analysis")}
      >
        Thoughts
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

      <button
        class="tab {activeTab === 'about' ? 'active' : ''}"
        role="tab"
        aria-selected={activeTab === "about"}
        tabindex={activeTab === "about" ? 0 : -1}
        on:click={() => (activeTab = "about")}
      >
        About
      </button>
    </div>
  {/if}

  {#if activeTab === "songs"}
    <DecadeSelector {showingData} {scrollToYear} />
  {/if}
</div>

{#if !isMobile || $drawerState !== "closed"}
  <div class="content" bind:this={contentEl}>
    {#if activeTab === "analysis"}
      <RenderCommentary {selectedInsight} />
    {:else if activeTab === "songs"}
      <div class="song-list" transition:fade>
        {#each showingData as year}
          <YearsSongList {year} {screenWidth} />
        {/each}
      </div>
    {:else if activeTab === "about"}
      <About />
    {/if}
  </div>
{/if}

<style>
  .song-list {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }

  .content {
    padding: 16px 8px 48px 8px;
    overflow-y: auto;
    scrollbar-width: none;
  }

  .tabs-wrapper {
    display: flex;
    gap: 12px;
    position: sticky;
    padding-bottom: 4px;
    top: 0;
    background-color: #fff;
    display: flex;
    flex-direction: column;
  }

  .tabs-wrapper::after {
    content: "";
    position: absolute;
    bottom: -20px; /* match padding-bottom */
    left: 0;
    width: 100%;
    height: 20px; /* adjust fade length */
    pointer-events: none;
    background: linear-gradient(
      to bottom,
      rgb(255, 255, 255),
      rgba(255, 255, 255, 0)
    );
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
