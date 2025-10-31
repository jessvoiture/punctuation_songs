<script>
  import { browser } from "$app/environment";
  import BarChart from "$lib/components/chart/BarChart.svelte";
  import Title from "$lib/components/Title.svelte";
  import ListWrapper from "$lib/components/details/ListWrapper.svelte";
  import { selectedOption, includeKeywordsParantheses } from "../stores.js";
  import SpotifyPlayer from "$lib/components/SpotifyPlayer.svelte";

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
<!-- 
<SpotifyPlayer name="Song 1" spotifyUri="1hKdDCpiI9mqz1jVHRKG0E" />
<SpotifyPlayer name="Song 2" spotifyUri="1xzi1Jcr7mEi9K2RfzLOqS" />
<SpotifyPlayer name="Song 3" spotifyUri="0VjIjW4GlUZAMYd2vXMi3b" /> -->

<div class="container">
  <div class="chart-wrapper">
    <Title {screenWidth} />
    <BarChart data={songs} {screenWidth} {screenHeight} {isMobile} />
  </div>

  <ListWrapper {screenWidth} data={songs} {screenHeight} {isMobile} />
</div>

<div
  id="embed-iframe"
  style="display:none; visibility:hidden;"
  aria-hidden="true"
></div>

<style>
  .container {
    display: flex;
    justify-content: center;
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
