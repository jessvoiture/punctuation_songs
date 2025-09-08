<script>
  import { scaleLinear } from "d3-scale";
  import { extent, min, max } from "d3-array";
  import {
    hoveredData,
    mouseX,
    mouseY,
    selectedMetric,
    isDataHovered,
    hoveredDataYear,
  } from "../../../stores";

  export let data;

  let tooltipWidth = 250;
  let tooltipHeight = 150;

  let extentData = [0, 100];
  let filteredData = [];
  let barcodeHeight = 40;
  let values = data.map((d) => d.percent_with_punc);
  let padding = 12;
  let barcodeWidth = tooltipWidth - padding * 2;

  $: {
    if ($selectedMetric === "Percent") {
      extentData = extent(data, (d) => d.percent_with_punc);
      values = data.map((d) => d.percent_with_punc);
    } else if ($selectedMetric === "Number") {
      extentData = extent(data, (d) => d.count_with_punc);
      values = data.map((d) => d.count_with_punc);
    }

    extentData = [Math.floor(extentData[0]), Math.ceil(extentData[1])];
  }

  $: xScale = scaleLinear().domain(extentData).range([0, barcodeWidth]);

  // $: xticks = xScale.ticks(3);

  $: domain = xScale.domain();
  $: xticks = [domain[0], (domain[0] + domain[1]) / 2, domain[1]];
</script>

<div
  class="tooltip"
  style="left: {$mouseX + 8}px; 
          top: {$mouseY - 60}px;"
>
  <div class="tooltip-content">
    <div class="tooltip-header">
      {$hoveredData.year}: {$hoveredData.count_with_punc} songs ({Math.round(
        $hoveredData.percent_with_punc * 10,
      ) / 10}% of charting songs)
    </div>

    <div class="barcode-wrapper">
      <div class="barcode-year-label">
        <svg width={tooltipWidth} height={80} class="barcode">
          <g transform={`translate(${padding}, 0)`}>
            {#each values as d, i}
              <text
                x={xScale(values[$hoveredData.year - 1958])}
                y="12"
                text-anchor="middle"
                font-size="12"
                fill={"#3c98ba"}
              >
                {$hoveredData.year}
              </text>
            {/each}
          </g>

          <g transform={`translate(${padding}, 20)`}>
            {#each values as d, i}
              <rect
                x={xScale(d)}
                y="0"
                width="2.5"
                height={barcodeHeight}
                class="chart-bar"
                fill={"#58b8db"}
                class:hovered={$hoveredData.year == 1958 + i}
              />
            {/each}
          </g>

          <g transform={`translate(${padding}, 68)`}>
            {#each xticks as d}
              <text x={xScale(d)} y="12" text-anchor="middle" font-size="12">
                {d}{#if $selectedMetric == "Percent"}%{/if}
              </text>
            {/each}
          </g>
        </svg>
      </div>
    </div>

    <div class="click-directive">Click on bar to view songs</div>
  </div>
</div>

<style>
  .tooltip {
    position: fixed;
    display: flex;
    justify-content: start;
    align-items: flex-start;
    box-sizing: border-box;
    z-index: 1000 !important;
    font-family: sans-serif;
    font-size: 14px;
    background-color: #fff;
    border-radius: 8px;
    border: 1px solid #ccc;
  }

  .tooltip-content {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin: 0;
    padding: 8px 12px;
    width: 250px;
    font-size: 14px;
  }

  .click-directive {
    font-size: 12px;
    color: #8c8c8c;
    font-style: italic;
  }

  .chart-bar {
    opacity: 0.1;
    transition:
      opacity 0.2s ease-in-out,
      fill 0.2s ease-in-out;
    cursor: pointer;
  }

  .hovered {
    opacity: 1;
  }

  text {
    font-size: 14px;
    font-weight: regular;
  }

  svg {
    overflow: visible;
  }
</style>
