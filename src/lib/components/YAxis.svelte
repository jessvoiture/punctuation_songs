<script>
  import { selectedMetric } from "../../stores";
  export let yScale;
  export let yticks;
  export let width;
</script>

<g class="y-axis">
  {#each yticks as t}
    <line x1={0} y1={yScale(t)} x2={width} y2={yScale(t)} stroke="lightgray" />

    <text
      x={2}
      y={yScale(t) - 12}
      text-anchor="start"
      fill="#2c2c2c"
      class="y-axis-text"
      >{t}
      {#if $selectedMetric === "Percent"}
        %
      {/if}
    </text>
  {/each}
</g>

<style>
  .y-axis-text {
    color: #8c8c8c;
  }
</style>
