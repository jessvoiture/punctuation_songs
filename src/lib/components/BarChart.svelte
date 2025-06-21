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
  import StackedBars from "./StackedBars.svelte";

  export let data;
  export let screenWidth;
  export let screenHeight;

  let height;
  let width;
  let innerWidth;
  let innerHeight;
  let yticks;
  let xticks;
  let showingData = data;

  const maxSongsPerYear = Math.max(
    ...data.flatMap((item) => item.years.map((y) => y.songs.length)),
  );

  console.log("Max songs per year:", maxSongsPerYear);

  const yMax = tweened(
    max(
      data
        .find((item) => item.type === "parentheses")
        .years.map((d) => d.percent_with_punc),
    ),
    {
      duration: 1000,
      easing: cubicInOut,
    },
  );

  $: if (screenWidth <= 860) {
    height = screenHeight - 240;
    width = 0.9 * screenWidth;
  } else {
    height = 0.75 * screenHeight;
    width = 0.6 * screenWidth;
  }

  let padding = { top: 40, right: 0, bottom: 30, left: 40 };
  $: innerWidth = width - padding.left - padding.right;
  $: innerHeight = height - padding.top - padding.bottom;

  $: if ($includeKeywordsParantheses && $selectedOption === "parentheses") {
    showingData =
      data.find((item) => item.type === "parantheses_no_keywords")?.years || [];
  } else {
    showingData =
      data.find((item) => item.type === $selectedOption)?.years || [];
  }

  $: if (showingData.length > 0) {
    if ($selectedMetric == "Percent") {
      const values = showingData.map((d) => d.percent_with_punc);
      yMax.set(max(values));
    } else if ($selectedMetric == "Number") {
      const values = showingData.map((d) => d.count_with_punc);
      yMax.set(max(values));
    }
  }

  $: xScale = scaleLinear().domain([1958, 2025]).range([0, innerWidth]);
  $: yScale = scaleLinear().domain([0, $yMax]).range([innerHeight, 0]);

  $: yticks = yScale.ticks(3);
  $: xticks = xScale.ticks(4);
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

        <g class="bars" transform={`translate(${padding.left}, 0)`}>
          <foreignObject x="0" y="0" width={innerWidth} height={innerHeight}>
            <div
              xmlns="http://www.w3.org/1999/xhtml"
              style="margin:0; padding:0; background:none; width:100%; height:100%;"
            >
              <StackedBars
                {xScale}
                {yScale}
                {showingData}
                {innerWidth}
                {innerHeight}
                {maxSongsPerYear}
              />
            </div>
          </foreignObject>
        </g>
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
