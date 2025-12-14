<script>
  import { slide } from "svelte/transition";
  import Dropdown from "./Dropdown.svelte";
  import ParenthesesToggle from "./ParenthesesToggle.svelte";
  import {
    selectedOption,
    selectedMetric,
    includeKeywordsParantheses,
    drawerState,
  } from "../../stores";

  export let screenWidth;

  const punc_options = [
    { option: "parentheses", displayOption: "parentheses" },
    { option: "asterisk", displayOption: "an asterisk" },
    { option: "slash", displayOption: "a slash" },
    { option: "apostrophe", displayOption: "an apostrophe" },
    { option: "period", displayOption: "a period" },
    { option: "dash", displayOption: "a dash" },
    { option: "comma", displayOption: "a comma" },
    { option: "exclamation", displayOption: "an exclamation mark" },
    { option: "question", displayOption: "a question mark" },
    { option: "ellipses", displayOption: "ellipses" },
    { option: "colons", displayOption: "a colon" },
    { option: "quote", displayOption: "quotation marks" },
    { option: "ampersand", displayOption: "an ampersand" },
  ];

  const metric_options = [
    { option: "Percent", displayOption: "Percent" },
    { option: "Number", displayOption: "Number" },
  ];
</script>

{#if screenWidth > 0}
  <div class="header">
    <!-- {#if ($drawerState == "closed") | !isMobile} -->
    <h1 class="title" transition:slide>
      <Dropdown value={selectedMetric} options={metric_options} /> of song titles
      with
      <Dropdown value={selectedOption} options={punc_options} />
    </h1>

    <!-- <h2 transition:slide>
      {#if $selectedMetric === "Percent"}
        Percent of
      {:else}
        Number of
      {/if}
      new charting songs in the Billboard Hot 100 per year
    </h2> -->
    <!-- {/if} -->

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
