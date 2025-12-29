<script>
  import DecadeSelector from "../details/DecadeSelector.svelte";
  import { crossfade } from "svelte/transition";
  import { drawerState, clickedYear, activeTab } from "../../../stores";

  export let isMobile;
</script>

<div class="tabs-wrapper">
  {#if !isMobile || $drawerState !== "closed"}
    <div class="tabs" transition:crossfade>
      <button
        class="tab {$activeTab === 'analysis' ? 'active' : ''}"
        role="tab"
        aria-selected={$activeTab === "analysis"}
        tabindex={$activeTab === "analysis" ? 0 : -1}
        on:click={() => activeTab.set("analysis")}
      >
        Thoughts
      </button>

      <button
        class="tab {$activeTab === 'songs' ? 'active' : ''}"
        role="tab"
        aria-selected={$activeTab === "songs"}
        tabindex={$activeTab === "songs" ? 0 : -1}
        on:click={() => activeTab.set("songs")}
      >
        Songs
      </button>

      <button
        class="tab {$activeTab === 'about' ? 'active' : ''}"
        role="tab"
        aria-selected={$activeTab === "about"}
        tabindex={$activeTab === "about" ? 0 : -1}
        on:click={() => activeTab.set("about")}
      >
        About
      </button>
    </div>
  {/if}
</div>

<style>
  .tabs-wrapper {
    display: flex;
    gap: 12px;
    position: sticky;
    padding-bottom: 8px;
    top: 0;
    background-color: #fff;
    display: flex;
    flex-direction: column;
    width: 100%;
  }

  .tabs-wrapper::after {
    content: "";
    position: absolute;
    bottom: -8px;
    left: 0;
    width: 100%;
    height: 8px;
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
