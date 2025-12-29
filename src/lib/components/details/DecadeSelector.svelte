<script>
  export let showingData;
  export let scrollToYear;

  $: yearsWithSongs = showingData.filter((year) => year.count_with_punc > 0);
  $: decades = Array.from(
    new Set(yearsWithSongs.map((y) => Math.floor(y.year / 10) * 10)),
  ).sort((a, b) => a - b);
</script>

<div class="decade-selector">
  <div class="label">Jump to</div>
  <div class="decade-buttons-wrapper">
    <div class="blur" id="left"></div>
    <div class="decade-buttons">
      {#each decades as decade}
        <button
          on:click={() => {
            const targetYear = yearsWithSongs
              .filter((y) => Math.floor(y.year / 10) * 10 === decade)
              .map((y) => y.year)
              .sort((a, b) => a - b)[0];
            if (targetYear) scrollToYear(targetYear);
          }}>{decade}s</button
        >
      {/each}
    </div>
    <div class="blur" id="right"></div>
  </div>
</div>

<style>
  .decade-selector {
    padding: 12px 12px 12px 12px;
    display: flex;
    align-items: center;
    gap: 4px;
    position: relative;
  }

  .decade-selector::after {
    content: "";
    position: absolute;
    bottom: -24px;
    left: 0;
    width: 100%;
    height: 24px;
    pointer-events: none;
    background: linear-gradient(
      to bottom,
      rgb(255, 255, 255),
      rgba(255, 255, 255, 0)
    );
  }

  .label {
    flex: 0 0 auto;
    overflow: hidden;
  }

  .decade-buttons-wrapper {
    position: relative;
    overflow: hidden;
    flex: 1 1 auto;
  }

  .decade-buttons {
    display: flex;
    gap: 8px;
    overflow-x: auto;
    padding: 0px 24px 0px 8px;
    flex-wrap: nowrap;
    white-space: nowrap;
    scrollbar-width: none;
  }

  .decade-buttons::-webkit-scrollbar {
    display: none;
  }

  .decade-buttons button {
    flex: 0 0 auto;
    padding: 4px 12px;
    border-radius: 16px;
    border: 1px solid #ddd;
    background: #f6f6f6;
    cursor: pointer;
    font-size: 14px;
    transition: background 0.2s;
  }

  .decade-buttons button:hover {
    background: #e0e0e0;
  }

  .blur {
    position: absolute;
    top: 0;
    bottom: 0;
    pointer-events: none;
  }

  #left {
    left: 0;
    width: 16px;
    background: linear-gradient(
      to right,
      rgb(255, 255, 255),
      rgba(255, 255, 255, 0)
    );
  }

  #right {
    right: 0;
    width: 48px;
    background: linear-gradient(
      to left,
      rgb(255, 255, 255),
      rgba(255, 255, 255, 0)
    );
  }
</style>
