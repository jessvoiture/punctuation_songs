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

  $: if (screenWidth <= 1000) {
    height = 0.7 * screenHeight;
    width = 0.9 * screenWidth;
  } else {
    height = 0.7 * screenHeight;
    width = 0.5 * screenWidth;
  }

  let padding = { top: 20, right: 0, bottom: 30, left: 40 };
  $: innerWidth = width - padding.left - padding.right;
  $: innerHeight = height - padding.top - padding.bottom;
  $: rectWidth = innerWidth / data.length - 1;

  $: tweenedY = tweened(
    data.map((d) => d.parantheses_pct),
    { duration: 2000, easing: cubicInOut }
  );
  $: yMax = max($tweenedY);

  $: xScale = scaleLinear()
    .domain(extent(data, (d) => d.year))
    .range([0, innerWidth]);

  $: yScale = scaleLinear()
    .domain([0, yMax * 1.2])
    .range([innerHeight, 0]);

  $: yticks = yScale.ticks(3);
  $: xticks = xScale.ticks(4);

  $: if ($selectedOption == "parantheses") {
    tweenedY.set(data.map((d) => d.parantheses_pct));
  } else if ($selectedOption == "an exclamation mark") {
    tweenedY.set(data.map((d) => d.exclamation_pct));
  } else if ($selectedOption == "a question mark") {
    tweenedY.set(data.map((d) => d.question_pct));
  } else if ($selectedOption == "a period") {
    tweenedY.set(data.map((d) => d.period_pct));
  } else if ($selectedOption == "an apostrophe") {
    tweenedY.set(data.map((d) => d.apostrophe_pct));
  } else if ($selectedOption == "a phonetic elision") {
    tweenedY.set(data.map((d) => d.phonetic_elision_pct));
  } else if ($selectedOption == "a contraction/possession") {
    tweenedY.set(data.map((d) => d.contraction_pct));
  } else if ($selectedOption == "a comma") {
    tweenedY.set(data.map((d) => d.comma_pct));
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
        {#each data as d, i}
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
