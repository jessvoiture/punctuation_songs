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
  <List data={songs} />
</div>

<style>
  .container {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    height: calc(100vh - 40px);
    width: 100%;
    flex-direction: row;
    align-content: flex-start;
    gap: 168px;
    padding-left: 40px;
    margin-top: 40px;
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
</style>
