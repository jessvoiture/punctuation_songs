<script>
  import { browser } from "$app/environment";
  import BarChart from "$lib/components/BarChart.svelte";
  import List from "$lib/components/List.svelte";
  import Title from "$lib/components/Title.svelte";

  export let data;

  let punctuation = data.punctuation;
  let songs = data.songs;

  let y = 0;

  let screenWidth;
  let screenHeight;

  function resize() {
    screenWidth = window.innerWidth;
    screenHeight = window.innerHeight;
  }

  if (browser) {
    resize();
  }
</script>

<svelte:window on:resize={resize} bind:scrollY={y} />

<div class="container">
  <div class="chart-wrapper">
    <Title />
    <BarChart data={songs} {screenWidth} {screenHeight} />
  </div>

  {#if screenWidth > 860}
    <List data={songs} />
  {/if}
</div>

<style>
  .container {
    display: flex;
    justify-content: center;
    width: 100%;
    height: calc(100vh - 40px);
    margin-top: 40px;
    flex-direction: row;
    align-content: flex-start;
    gap: 10%;
    max-width: 100%;
    box-sizing: border-box;
  }

  .chart-wrapper {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    align-content: flex-start;
    gap: 24px;
    flex-basis: auto;
    width: fit-content;
  }

  @media (max-width: 860px) {
    .container {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      height: 100%;
      width: 100%;
      flex-direction: row;
      align-content: flex-start;
      gap: 10%;
    }

    .chart-wrapper {
      display: flex;
      flex-direction: column;
      gap: 24px;
      flex-basis: auto;
      width: fit-content;
      max-width: 90%;
    }
  }

  @media (min-width: 861px) {
    .container {
      align-items: flex-start;
      padding-left: 40px;
    }

    .chart-wrapper {
      max-width: 60%;
    }
  }
</style>
