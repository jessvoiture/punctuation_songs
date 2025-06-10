<script>
  import { slide } from "svelte/transition";
  import Dropdown from "./Dropdown.svelte";
  import ParenthesesToggle from "./ParenthesesToggle.svelte";
  import {
    selectedOption,
    selectedMetric,
    includeKeywordsParantheses,
  } from "../../stores";

  export let screenWidth;

  const punc_options = [
    "parentheses",
    "apostrophe",
    "comma",
    "period",
    "exclamation",
    "question",
    "slash",
    "dash",
    "ellipses",
    "colons",
    "quote",
    "asterisk",
    "ampersand",
  ];

  const metric_options = ["Percent", "Number"];
</script>

{#if screenWidth > 0}
  <div class="header">
    <h1 class="title">
      <Dropdown value={selectedMetric} options={metric_options} /> of songs with
      <Dropdown value={selectedOption} options={punc_options} />
    </h1>

    <h2>
      {#if $selectedMetric === "Percent"}
        Percent of
      {:else}
        Number of
      {/if}
      new charting songs per year in the Billboard Hot 100 with {$selectedOption}
    </h2>

    <ParenthesesToggle />
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
</style>
