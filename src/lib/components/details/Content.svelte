<script>
  import { fade, slide, crossfade } from "svelte/transition";
  import {
    selectedOption,
    clickedYear,
    drawerState,
    activeTab,
  } from "../../../stores";
  import YearsSongList from "./YearsSongList.svelte";
  import { insight } from "../../../utils/insight.js";
  import RenderCommentary from "./RenderCommentary.svelte";
  import About from "./About.svelte";
  import DecadeSelector from "./DecadeSelector.svelte";

  export let showingData;
  export let screenWidth;
  export let isMobile;

  $: selectedInsight = insight.find((d) => d.type === $selectedOption);

  let showingSongList = false;
  let contentEl;

  $: if (contentEl && $activeTab) {
    contentEl.scrollTop = 0;
  }

  $: clickedYear.subscribe((year) => {
    if (year) {
      scrollToYear(year);
    }
  });

  function scrollToYear(year) {
    console.log("scrolling to year:", year);
    activeTab.set("songs");

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

{#if !isMobile || $drawerState !== "closed"}
  {#if $activeTab === "songs"}
    <DecadeSelector {showingData} {scrollToYear} />
  {/if}

  <div class="content" bind:this={contentEl}>
    {#if $activeTab === "analysis"}
      <RenderCommentary {selectedInsight} />
    {:else if $activeTab === "songs"}
      <div class="song-list" transition:fade>
        {#each showingData as year}
          <YearsSongList {year} {screenWidth} />
        {/each}
      </div>
    {:else if $activeTab === "about"}
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
    padding: 8px 8px 48px 8px;
    overflow-y: auto;
    scrollbar-width: none;
  }
</style>
