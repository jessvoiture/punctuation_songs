<script>
  import Dropdown from "./Dropdown.svelte";
  import { selectedOption } from "../../stores";
</script>

<div class="header">
  <h1 class="title">
    Percent of songs with <Dropdown />
  </h1>

  <h2>New charting songs on the Billboard Hot 100</h2>
</div>

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
  }
</style>
