<script>
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
  export let yScale;
  export let showingData;
  export let innerWidth;
  export let innerHeight;

  let rectWidth;

  $: rectWidth = innerWidth / showingData.length - 1;

  const handleMouseover = function (event, d) {
    hoveredData.set(d);
    hoveredDataYear.set(d.year);
    mouseX.set(event.clientX);
    mouseY.set(event.clientY);
    isDataHovered.set(true);
  };

  const handleFocus = function (event, d) {
    const rect = event.target.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;
    hoveredData.set(d);
    hoveredDataYear.set(d.year);
    mouseX.set(centerX);
    mouseY.set(centerY);
    isDataHovered.set(true);
  };

  const handleMouseout = function () {
    hoveredData.set(undefined);
    hoveredDataYear.set(undefined);
    isDataHovered.set(false);
  };

  const onClick = function (event, d) {
    clickedYear.set(d.year);
    event.target.blur();
    handleMouseover(event, d);
  };
</script>

{#each showingData as d, i}
  <!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
  <rect
    in:slide={{ delay: 500 + j * 100 }}
    out:fade={{ duration: 800 }}
    x={xScale(d.year)}
    y={yScale(tweenedY[i])}
    id={d.year}
    width={rectWidth}
    height={innerHeight - yScale(tweenedY[i])}
    fill={"#58b8db"}
    class={"chart-bar"}
    class:hovered={$isDataHovered & ($hoveredDataYear == d.year)}
    aria-label="{d.percent_with_punc}% of songs in {d.year} contain {$selectedOption}."
    role="graphics-object"
    on:mouseover={function (event) {
      handleMouseover(event, d);
    }}
    on:mouseout={function () {
      handleMouseout();
    }}
    on:focus={function (event) {
      handleFocus(event, d);
    }}
    on:blur={function () {
      handleMouseout();
    }}
    on:click={function (event) {
      onClick(event, d);
    }}
    on:keydown={function (event) {
      if (event.key === "Enter" || event.key === " ") {
        onClick(d);
      }
    }}
  />
{/each}

<style>
  .chart-bar {
    opacity: 0.6;
    transition:
      opacity 0.2s ease-in-out,
      fill 0.2s ease-in-out;
  }

  .hovered {
    opacity: 1;
  }
</style>
