<script>
  import { scaleLinear } from "d3-scale";
  import { extent, min, max } from "d3-array";
  import { cubicOut, cubicInOut } from "svelte/easing";
  import { tweened } from "svelte/motion";
  import { fade } from "svelte/transition";

  import {
    selectedOption,
    selectedMetric,
    hoveredData,
    hoveredDataYear,
    isDataHovered,
    mouseX,
    mouseY,
    clickedYear,
    includeKeywordsParantheses,
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
    if ($selectedOption === "parentheses") {
      height = screenHeight - 280;
    } else {
      height = screenHeight - 240;
    }
    width = 0.9 * screenWidth;
  } else {
    height = 0.72 * screenHeight;
    width = 0.6 * screenWidth;
  }

  let padding = { top: 20, right: 0, bottom: 30, left: 40 };
  $: innerWidth = width - padding.left - padding.right;
  $: innerHeight = height - padding.top - padding.bottom;

  $: tweenedY = tweened(
    data
      .find((item) => item.type == "parentheses")
      .years.map((d) => d.percent_with_punc),
    { duration: 2000, easing: cubicInOut },
  );
  $: yMax = max($tweenedY);

  $: if ($includeKeywordsParantheses && $selectedOption === "parentheses") {
    showingData =
      data.find((item) => item.type === "parantheses_no_keywords")?.years || [];
  } else {
    showingData =
      data.find((item) => item.type === $selectedOption)?.years || [];
  }

  $: yExtent = extent(showingData.map((d) => d.year));

  $: xScale = scaleLinear().domain([1958, 2026]).range([0, innerWidth]);

  $: yScale = scaleLinear()
    .domain([0, yMax * 1.2])
    .range([innerHeight, 0]);

  $: yticks = yScale.ticks(3);
  $: xticks = xScale.ticks(4);

  $: {
    let selectedData;

    if ($includeKeywordsParantheses && $selectedOption === "parentheses") {
      selectedData = data.find(
        (item) => item.type === "parantheses_no_keywords",
      );
    } else {
      selectedData = data.find((item) => item.type === $selectedOption);
    }

    if (selectedData) {
      if ($selectedMetric == "Percent") {
        tweenedY.set(selectedData.years.map((d) => d.percent_with_punc));
      } else if ($selectedMetric == "Number") {
        tweenedY.set(selectedData.years.map((d) => d.count_with_punc));
      }
    }
  }
</script>

<div class="bar-chart">
  {#if showingData.length > 0 && width > 0 && height > 0}
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
  {/if}
</div>

<!-- Tooltip -->
{#if ($hoveredData != undefined) & $isDataHovered}
  <div transition:fade={{ duration: 300, easing: cubicOut }}>
    <Tooltip {screenHeight} {screenWidth} data={showingData} />
  </div>
{/if}
