<script>
  import { tweened } from "svelte/motion";
  import { slide, fade } from "svelte/transition";
  import { max } from "d3-array";
  import {
    selectedOption,
    hoveredData,
    hoveredDataYear,
    isDataHovered,
    mouseX,
    mouseY,
    clickedYear,
  } from "../../stores";

  export let tweenedY;
  export let xScale;
  export let showingData;

  export let innerWidth;
  export let innerHeight;

  $: console.log(showingData);

  let rectWidth;
  let rectHeight;

  $: rectWidth = innerWidth / showingData.length - 1;
  $: rectHeight =
    tweenedY && tweenedY.length ? innerHeight / Math.max(...tweenedY) - 1 : 0;
</script>

{#each showingData as d, i}
  <!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
  {#each d.songs as song, j}
    <rect
      x={xScale(d.year)}
      y={innerHeight - (rectHeight + 1) * (j + 1)}
      id={d.year}
      width={rectWidth}
      height={rectHeight}
      fill={"#58b8db"}
      class={"song-bar"}
      aria-label="{song.title_og} by {song.performer_og} first appeared on the Billboard Hot 100 on {song.chart_week}"
      role="graphics-object"
    />
  {/each}
{/each}

<style>
  .song-bar {
    border-radius: 4px;
  }
</style>
