<script>
  import { hoveredDataYear, selectedOption, isDataHovered } from "../../stores";
  import { highlightBySelectedOption } from "../../utils/highlightRegex.js";

  export let year;
  export let screenWidth;

  let isScreenWide = screenWidth > 860;
  $: isScreenWide = screenWidth > 860;

  function onMouseover(year) {
    hoveredDataYear.set(year);
    isDataHovered.set(true);
  }

  function onMouseout() {
    hoveredDataYear.set(undefined);
    isDataHovered.set(false);
  }
</script>

{#if year.count_with_punc > 0}
  <!-- svelte-ignore a11y_no_static_element_interactions -->
  <!-- svelte-ignore a11y_mouse_events_have_key_events -->
  <div
    class="year-group"
    on:mouseover={() => onMouseover(year.year)}
    on:mouseout={onMouseout}
    class:hovered={($hoveredDataYear === year.year) & isScreenWide}
  >
    <!-- this states the year -->
    <div class="year-header" id="year-{year.year}">
      {year.year}: {year.count_with_punc} songs ({Math.round(
        year.percent_with_punc * 10,
      ) / 10}% of charting songs)
    </div>

    <!-- this is the songs in the year -->
    <div class="song-list">
      {#each year.songs as song}
        <div class="song-item">
          <div class="song-title">
            {@html highlightBySelectedOption(song.title_og, $selectedOption)}
          </div>

          <div class="song-performer">
            {song.performer_og}
          </div>
        </div>
      {/each}
    </div>
  </div>
{/if}

<style>
  .song-list {
    /* max-width: 350px; */
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
</style>
