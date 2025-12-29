<script>
  import { browser } from "$app/environment";
  import BarChart from "$lib/components/chart/BarChart.svelte";
  import Title from "$lib/components/Title.svelte";
  import ContentWrapper from "$lib/components/details/ContentWrapper.svelte";
  import { selectedOption, includeKeywordsParantheses } from "../stores.js";

  export let data;

  let punctuation = data.punctuation;
  let songs = data.songs;
  let isMobile = false;

  let y = 0;

  let screenWidth;
  let screenHeight;

  $: isMobile = screenWidth < 750 ? true : false;

  function resize() {
    screenWidth = window.innerWidth;
    screenHeight = window.innerHeight;
  }

  if (browser) {
    resize();
  }
</script>

<svelte:window on:resize={resize} bind:scrollY={y} />

{#if screenWidth > 0}
  <div class="container">
    <div class="chart-wrapper">
      <Title {screenWidth} {isMobile} />
      <BarChart data={songs} {screenWidth} {screenHeight} {isMobile} />
    </div>

    <ContentWrapper {screenWidth} data={songs} {screenHeight} {isMobile} />
  </div>
{/if}

<style>
  .container {
    display: flex;
    justify-content: space-between;
    width: 100%;
    height: 100%;
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
    overscroll-behavior: none;
    touch-action: none;
  }

  /* small screens */
  @media (max-width: 750px) {
    .container {
      display: flex;
      justify-content: start;
      align-items: center;
      height: calc(100vh - 80px);
      width: 100%;
      flex-direction: column;
      align-content: center;
      gap: 10%;
      margin-top: 16px;
    }

    .chart-wrapper {
      display: flex;
      flex-direction: column;
      gap: 12px;
      flex-basis: auto;
      width: fit-content;
      max-width: 90%;
    }
  }

  /* big screens */
  @media (min-width: 750px) {
    .container {
      align-items: flex-start;
      flex-direction: row;
      padding-left: 40px;
      height: calc(100vh - 40px);
      margin-top: 40px;
    }

    .chart-wrapper {
      max-width: 60%;
    }
  }
</style>
