<script>
  import { scaleLinear } from "d3-scale";

  export let screenHeight;
  export let screenWidth;
  export let data;

  let height;
  let width;
  let chartWidth = 180;

  $: padding = { top: 40, right: 32, bottom: 32, left: 32 };

  $: height = screenHeight - 80;

  $: if (screenWidth <= 860) {
    width = 0.9 * screenWidth;
  } else {
    width = 0.6 * screenWidth;
  }

  $: chartCols = Math.floor(width / chartWidth);
  $: chartWidthNew = width / chartCols;
  $: chartRows = Math.ceil(data.length / chartCols);
  $: chartHeight = height / chartRows;
  $: innerWidth = chartWidthNew - padding.left - padding.right;
  $: innerHeight = chartHeight - padding.top - padding.bottom;

  // Compute rect width based on data length for apostrophe
  $: rectWidth =
    innerWidth /
      data.find((item) => item.type === "apostrophe")?.years.length ?? 1;

  // Compute xScale
  $: xScale = scaleLinear().domain([1958, 2025]).range([0, innerWidth]);

  // Cache max % per type
  $: maxPercentsPerPunc = data.map((item) => ({
    type: item.type,
    maxPercent: Math.max(...item.years.map((entry) => entry.percent_with_punc)),
  }));

  function getYScale(value, type) {
    const typeData = maxPercentsPerPunc.find((item) => item.type === type);
    if (!typeData) return innerWidth;

    const yScale = scaleLinear()
      .domain([0, typeData.maxPercent])
      .range([innerHeight, 0]);

    return yScale(value);
  }
</script>

<!-- Grid container for small multiples -->
<div
  class="grid"
  style="grid-template-columns: repeat({chartCols}, 1fr); width: {width}px;"
>
  {#each data as year}
    <div
      class="chart-container"
      style="width: {chartWidthNew}px; height: {chartHeight}px;"
    >
      <svg height={chartHeight} width={chartWidthNew}>
        <g transform="translate({padding.left}, 0)">
          <text x="0" y="16" font-size="12">{year.type}</text>
          {#each year.years as d}
            <g transform="translate(0, {padding.top})">
              <rect
                x={xScale(d.year)}
                y={getYScale(d.percent_with_punc, year.type)}
                width={rectWidth}
                height={innerHeight - getYScale(d.percent_with_punc, year.type)}
                fill="#58b8db"
              />
            </g>
          {/each}
        </g>
      </svg>
    </div>
  {/each}
</div>

<style>
  .grid {
    display: grid;
    gap: 0;
    justify-items: center;
    margin: 0 auto;
  }

  .chart-container {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
</style>
