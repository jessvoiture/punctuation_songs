<script>
  import { browser } from "$app/environment";
  import BarChart from "$lib/components/BarChart.svelte";
  import Title from "$lib/components/Title.svelte";

  export let data;

  let punctuation = data.punctuation;

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

<main>
  <div class="container">
    <div class="chart-wrapper">
      <Title />
      <BarChart data={punctuation} {screenWidth} {screenHeight} />
    </div>
  </div>
</main>

<style>
  .container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    width: 100%;
    flex-direction: column;
    align-content: flex-start;
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
