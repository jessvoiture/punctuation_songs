<script>
  import { browser } from "$app/environment";
  import BarChart from "$lib/components/BarChart.svelte";
  import List from "$lib/components/List.svelte";
  import Title from "$lib/components/Title.svelte";
  import ListDrawer from "$lib/components/ListDrawer.svelte";
  import { selectedOption, includeKeywordsParantheses } from "../stores.js";
  import { slide } from "svelte/transition";

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
    <Title {screenWidth} />
    <BarChart data={songs} {screenWidth} {screenHeight} />
  </div>

  {#if screenWidth >= 860}
    <List data={songs} {screenWidth} />
  {:else if screenWidth < 860}
    <ListDrawer data={songs} {screenHeight} />
  {/if}
</div>

<style>
  .container {
    display: flex;
    justify-content: center;
    width: 100%;
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

  /* small screens */
  @media (max-width: 860px) {
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
  @media (min-width: 861px) {
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
