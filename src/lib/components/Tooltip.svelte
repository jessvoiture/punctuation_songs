<script>
  import { hoveredData, mouseX, mouseY } from "../../stores";

  let tooltipWidth = 250;
  let tooltipHeight = 150;
  let padding = 12;
</script>

<div
  class="tooltip"
  style="left: {$mouseX + 8}px; 
          top: {$mouseY}px;"
>
  <div class="tooltip-content">
    <div class="tooltip-header">
      {$hoveredData.year}: {$hoveredData.count_with_punc} songs ({Math.round(
        $hoveredData.percent_with_punc * 10,
      ) / 10}% of charting songs)
    </div>
    <div class="click-directive">Click bar to view songs</div>
  </div>
</div>

<style>
  .tooltip {
    position: fixed;
    padding: 0px;
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
    padding: 4px;
    width: 250px;
    font-size: 14px;
  }

  .click-directive {
    font-size: 12px;
    color: #8c8c8c;
    font-style: italic;
  }
</style>
