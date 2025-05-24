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

<Title />
<BarChart data={punctuation} {screenWidth} {screenHeight} />
