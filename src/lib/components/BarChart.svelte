<script>
  import { scaleLinear } from "d3-scale";
  import { extent, min, max } from "d3-array";
  import { cubicOut, cubicInOut } from "svelte/easing";
  import { tweened } from "svelte/motion";

  import { selectedOption } from "../../stores";

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
  let rectWidth;
  let showingData = data;
  let yExtent;

  $: console.log("selected Option", $selectedOption);

  $: if (screenWidth <= 1000) {
    height = 0.7 * screenHeight;
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
    { duration: 2000, easing: cubicInOut }
  );
  $: yMax = max($tweenedY);

  $: showingData = data.find((d) => d.type === $selectedOption)?.years || [];
  $: yExtent = extent(showingData.map((d) => d.year));
  $: rectWidth = innerWidth / showingData.length - 1;

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
      <g class="y-axis">
        {#each yticks as t}
          <line
            x1={0}
            y1={yScale(t)}
            x2={width}
            y2={yScale(t)}
            stroke="lightgray"
          />

          <text
            x={2}
            y={yScale(t) - 12}
            text-anchor="start"
            fill="#2c2c2c"
            class="y-axis-text">{t}%</text
          >
        {/each}
      </g>

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
        {#each showingData as d, i}
          <rect
            x={xScale(d.year)}
            y={yScale($tweenedY[i])}
            id={d.year}
            width={rectWidth}
            height={innerHeight - yScale($tweenedY[i])}
            fill="steelblue"
          />
        {/each}
      </g>
    </g>
  </svg>
</div>

<style>
  text {
    font-family: sans-serif;
    font-size: 16px;
  }

  .y-axis-text {
    color: #8c8c8c;
  }
</style>
