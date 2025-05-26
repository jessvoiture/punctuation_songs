<script>
  import { fade, slide } from "svelte/transition";
  import { selectedOption } from "../../stores";

  export let data;

  let showingSongList = false;
  let buttonText = "Show songs";

  let showingData = data.find((d) => d.type === "parantheses")?.years || [];
  $: showingData = data.find((d) => d.type === $selectedOption)?.years || [];

  function toggleSongList() {
    showingSongList = !showingSongList;
  }

  $: buttonText = showingSongList ? "Hide songs" : "Show songs";
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
        <span class="chevron">{showingSongList ? "▲" : "▼"}</span>
      </button>
    </div>

    {#if showingSongList}
      <div id="list" class="body-text" transition:fade>
        {#each showingData as year}
          {#if year.count_with_punc > 0}
            <div class="year-group">
              <div class="year-header">{year.year}</div>

              <div class="song-list">
                {#each year.songs as song}
                  <div class="song-item">
                    <div class="song-title">
                      {song.title_og}
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
  }

  .details-header {
    position: fixed;
  }

  .details {
    width: 100%;
    max-width: 350px;
    display: flex;
    gap: 16px;
    flex-direction: column;
  }

  #list {
    display: flex;
    flex-direction: column;
    gap: 24px;
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
  }

  .toggle-button:hover {
    background-color: #f6f6f6;
  }

  .chevron {
    font-size: 14px;
    color: inherit;
    background: none;
    border: none;
  }
</style>
