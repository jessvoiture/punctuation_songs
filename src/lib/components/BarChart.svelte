<script>
  import { scaleLinear } from "d3-scale";
  import { extent, min, max } from "d3-array";
  import { cubicOut, cubicInOut } from "svelte/easing";
  import { tweened } from "svelte/motion";
  import { fade } from "svelte/transition";

  import {
    selectedOption,
    hoveredData,
    hoveredDataYear,
    isDataHovered,
    mouseX,
    mouseY,
    clickedYear,
  } from "../../stores";
  import Tooltip from "./Tooltip.svelte";
  import Bars from "./Bars.svelte";
  import YAxis from "./YAxis.svelte";

  export let data;
  export let screenWidth;
  export let screenHeight;

  let tweenedY;
  let yMax;
  let height;
  let width;
  let innerWidth;
  let innerHeight;
  let yticks;
  let xticks;
  let showingData = data;
  let yExtent;

  $: if (screenWidth <= 860) {
    height = 0.66 * screenHeight;
    width = 0.9 * screenWidth;
  } else {
    height = 0.75 * screenHeight;
    width = 0.6 * screenWidth;
  }

  let padding = { top: 20, right: 0, bottom: 30, left: 40 };
  $: innerWidth = width - padding.left - padding.right;
  $: innerHeight = height - padding.top - padding.bottom;

  $: tweenedY = tweened(
    data
      .find((item) => item.type == "parantheses")
      .years.map((d) => d.percent_with_punc),
    { duration: 2000, easing: cubicInOut },
  );
  $: yMax = max($tweenedY);

  $: showingData = data.find((d) => d.type === $selectedOption)?.years || [];
  $: yExtent = extent(showingData.map((d) => d.year));

  $: xScale = scaleLinear().domain([1958, 2025]).range([0, innerWidth]);

  $: yScale = scaleLinear()
    .domain([0, yMax * 1.2])
    .range([innerHeight, 0]);

  $: yticks = yScale.ticks(3);
  $: xticks = xScale.ticks(4);

  $: {
    const selectedData = data.find((item) => item.type === $selectedOption);
    if (selectedData) {
      tweenedY.set(selectedData.years.map((d) => d.percent_with_punc));
    }
  }
</script>

<div class="bar-chart">
  <svg {width} {height}>
    <g transform={`translate(0, ${padding.top})`}>
      <YAxis {yScale} {yticks} {width} />

      <g class="x-axis" transform={`translate(${padding.left}, 0)`}>
        {#each xticks as t}
          <text
            x={xScale(t) + 5}
            y={innerHeight + 20}
            text-anchor="middle"
            fill="black">{t}</text
          >
        {/each}
      </g>

      <Bars
        tweenedY={$tweenedY}
        {xScale}
        {yScale}
        {showingData}
        paddingLeft={padding.left}
        {innerWidth}
        {innerHeight}
      />
    </g>
  </svg>
</div>

<!-- Tooltip -->
{#if ($hoveredData != undefined) & $isDataHovered}
  <div transition:fade={{ duration: 300, easing: cubicOut }}>
    <Tooltip {screenHeight} {screenWidth} data={showingData} />
  </div>
{/if}
