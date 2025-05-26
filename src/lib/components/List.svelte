<script>
  import { fade, slide } from "svelte/transition";
  import { selectedOption } from "../../stores";
  import { highlightBySelectedOption } from "../../utils/highlightRegex.js";

  export let data;

  let showingSongList = false;
  let buttonText = "Show songs";

  let showingData = data.find((d) => d.type === "parantheses")?.years || [];
  $: showingData = data.find((d) => d.type === $selectedOption)?.years || [];

  $: buttonText = showingSongList ? "Hide songs" : "Show songs";

  function toggleSongList() {
    showingSongList = !showingSongList;
  }

  function highlightParentheses(str, className = 'highlight') {
    return str.replace(/\([^)]*\)/g, match => `<span class="${className}">${match}</span>`);
}

console.log("test", highlightParentheses("This is a test (with parentheses) and more text (another one)."));

</script>

<div class="details-wrapper">
  <div class="details">
    <div class="details-header">
      <div id="commentary" class="body-text">
        <p>
          This chart shows the percentage of punctuation marks used in the text
          over the years. The data is based on a sample of texts from 1958 to
          2025.
        </p>
      </div>

      <button on:click={toggleSongList} class="toggle-button">
        {buttonText}
        <i class="material-icons chevron" class:opened={showingSongList}> keyboard_arrow_down </i>
      </button>
    </div>

    {#if showingSongList}
      <div id="list" class="body-text" transition:fade>
        {#each showingData as year}
          {#if year.count_with_punc > 0}
            <div class="year-group">
              <div class="year-header">{year.year}: {year.count_with_punc} songs ({Math.round(year.percent_with_punc * 10) / 10}% of charting songs)</div>

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
        {/each}
      </div>
    {/if}
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
    max-width: 300px;
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .details {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
  }

  #list {
    display: flex;
    flex-direction: column;
    gap: 24px;
    margin-bottom: 48px;
    overflow-y: auto;
    max-height: 100%; 
    padding-right: 32px;
  }

  .song-list {
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

  .highlight {
    background-color: #baeaff;
    padding: 2px 4px;
    border-radius: 4px;
  }
</style>
