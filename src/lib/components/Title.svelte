<script>
  import Dropdown from "./Dropdown.svelte";
  import { selectedOption } from "../../stores";

  export let screenWidth;
</script>

{#if screenWidth > 0}
  <div class="header">
    <h1 class="title">
      Percent of songs with <Dropdown />
    </h1>

    <h2>
      Songs with selected punctuation as a percent of new charting songs on the
      Billboard Hot 100 per year
    </h2>
  </div>
{/if}

<style>
  .header {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
    width: 100%;
  }

  h1 {
    margin: 0;
    font-size: 24px;
    font-family: sans-serif;
  }

  h2 {
    margin: 0;
    font-size: 20px;
    font-family: sans-serif;
    font-weight: normal;
    color: #8c8c8c;
    line-height: 1.2;
  }
</style>
