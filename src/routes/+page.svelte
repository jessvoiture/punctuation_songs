<script>
  import { browser } from "$app/environment";
  import BarChart from "$lib/components/BarChart.svelte";
  import List from "$lib/components/List.svelte";
  import Title from "$lib/components/Title.svelte";

  export let data;

  let punctuation = data.punctuation;
  let songs = data.songs;
  console.log(songs);

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
    height: 100vh;
    width: 100vw;
    flex-direction: row;
    align-content: flex-start;
    gap: 72px;
    margin-left: 32px;
    margin-top: 32px;
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
