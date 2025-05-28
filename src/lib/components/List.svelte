<script>
  import { fade, slide } from "svelte/transition";
  import {
    selectedOption,
    isDataHovered,
    hoveredData,
    clickedYear,
    hoveredDataYear,
  } from "../../stores";
  import { highlightBySelectedOption } from "../../utils/highlightRegex.js";

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

  function highlightParentheses(str, className = "highlight") {
    return str.replace(
      /\([^)]*\)/g,
      (match) => `<span class="${className}">${match}</span>`,
    );
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

  function onMouseover(year) {
    hoveredDataYear.set(year);
    isDataHovered.set(true);
    console.log("Hovered year:", year);
  }

  function onMouseout() {
    hoveredDataYear.set(undefined);
    isDataHovered.set(false);
  }
</script>

<div class="details-wrapper">
  <div class="details">
    <div class="details-header">
      <div id="commentary" class="body-text">
        <p>Intelligent insight.</p>
      </div>

      <button on:click={toggleSongList} class="toggle-button">
        {buttonText}
        <i class="material-icons chevron" class:opened={showingSongList}>
          keyboard_arrow_down
        </i>
      </button>
    </div>

    <div class="song-list-wrapper">
      {#if showingSongList}
        <div id="list" class="body-text" transition:fade>
          {#each showingData as year}
            <!-- svelte-ignore a11y_mouse_events_have_key_events -->
            {#if year.count_with_punc > 0}
              <!-- svelte-ignore a11y_no_static_element_interactions -->
              <div
                class="year-group"
                on:mouseover={() => onMouseover(year.year)}
                on:mouseout={onMouseout}
                class:hovered={$hoveredDataYear === year.year}
              >
                <div class="year-header" id="year-{year.year}">
                  {year.year}: {year.count_with_punc} songs ({Math.round(
                    year.percent_with_punc * 10,
                  ) / 10}% of charting songs)
                </div>
                <div class="song-list">
                  {#each year.songs as song}
                    <div class="song-item">
                      <div class="song-title">
                        {@html highlightBySelectedOption(
                          song.title_og,
                          $selectedOption,
                        )}
                      </div>

                      <div class="song-performer">
                        {song.performer_og}
                      </div>
                    </div>
                  {/each}
                </div>
              </div>
            {/if}
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

  #list {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }

  .year-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
    padding: 8px;
    border-radius: 8px;
    background-color: #fff;
    transition: background-color 0.3s ease;
  }

  .hovered {
    background-color: #f6f6f6;
  }

  .song-list {
    max-width: 350px;
    display: flex;
    flex-direction: column;
    gap: 12px;
  }

  .year-header {
    font-weight: bold;
    margin-bottom: 8px;
  }

  .song-item {
    gap: 4px;
    display: flex;
    flex-direction: column;
  }

  .song-performer {
    color: #8c8c8c;
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
