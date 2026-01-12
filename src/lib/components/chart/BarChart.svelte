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
    drawerState,
    drawerHeight,
  } from "../../../stores";
  import Tooltip from "./Tooltip.svelte";
  import Bars from "./Bars.svelte";
  import YAxis from "./YAxis.svelte";

  export let data;
  export let screenWidth;
  export let screenHeight;
  export let isMobile;

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

  const tweenedHeight = tweened(200, {
    duration: 300,
    easing: cubicOut,
  });

  $: {
    let targetH;
    let targetW;

    if (isMobile) {
      targetW = screenWidth - 24;

      // when the drawer is closed the subtitle is visible
      if ($drawerState == "closed") {
        targetH = screenHeight - $drawerHeight - 220;
        // when the drawer is open the subtitle is hidden
      } else {
        targetH = screenHeight - $drawerHeight - 160;
      }

      targetH = Math.max(targetH, 0.25 * screenHeight);
    } else {
      targetW = 0.6 * screenWidth;
      targetH = 0.72 * screenHeight;
    }

    width = targetW;
    tweenedHeight.set(targetH);
  }

  let padding = { top: 20, right: 0, bottom: 30, left: 40 };
  $: innerWidth = width - padding.left - padding.right;
  $: innerHeight = $tweenedHeight - padding.top - padding.bottom;

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

  $: xScale = scaleLinear().domain([1958, 2025]).range([0, innerWidth]);

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
  {#if showingData.length > 0 && width > 0 && $tweenedHeight > 0}
    <svg {width} height={$tweenedHeight}>
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
          {isMobile}
        />
      </g>
    </svg>
  {/if}
</div>

<!-- Tooltip -->
{#if ($hoveredData != undefined) & $isDataHovered}
  <div transition:fade={{ duration: 300, easing: cubicOut }}>
    <Tooltip {screenHeight} {screenWidth} data={showingData} {isMobile} />
  </div>
{/if}
