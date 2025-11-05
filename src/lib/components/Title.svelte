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
    { option: "parentheses", displayOption: "parentheses" },
    { option: "apostrophe", displayOption: "an apostrophe" },
    { option: "comma", displayOption: "a comma" },
    { option: "period", displayOption: "a period" },
    { option: "exclamation", displayOption: "an exclamation mark" },
    { option: "question", displayOption: "a question mark" },
    { option: "slash", displayOption: "a slash" },
    { option: "dash", displayOption: "a dash" },
    { option: "ellipses", displayOption: "ellipses" },
    { option: "colons", displayOption: "a colon" },
    { option: "quote", displayOption: "quotation marks" },
    { option: "asterisk", displayOption: "an asterisk" },
    { option: "ampersand", displayOption: "an ampersand" },
  ];

  const metric_options = [
    { option: "Percent", displayOption: "Percent" },
    { option: "Number", displayOption: "Number" },
  ];
</script>

{#if screenWidth > 0}
  <div class="header">
    <h1 class="title">
      <Dropdown value={selectedMetric} options={metric_options} /> of song titles
      containing
      <Dropdown value={selectedOption} options={punc_options} />
    </h1>

    <h2>
      {#if $selectedMetric === "Percent"}
        Percent of
      {:else}
        Number of
      {/if}
      new charting songs in the Billboard Hot 100 per year
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
