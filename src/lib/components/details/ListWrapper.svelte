<script>
  import { selectedOption, includeKeywordsParantheses } from "../../../stores";
  import List from "./List.svelte";
  import ListDrawer from "./ListDrawer.svelte";

  export let screenHeight;
  export let screenWidth;
  export let data;
  export let isMobile;

  let showingData = data.find((d) => d.type === "parentheses")?.years || [];
  let showingData24 = showingData.filter((d) => Number(d.year) <= 2024);

  $: if ($includeKeywordsParantheses && $selectedOption === "parentheses") {
    showingData =
      data.find((item) => item.type === "parantheses_no_keywords")?.years || [];
  } else {
    showingData = data.find((d) => d.type === $selectedOption)?.years || [];
  }
</script>

{#if !isMobile}
  <div class="details-wrapper">
    <List showingData={showingData24} {screenWidth} />
  </div>
{:else if isMobile}
  <ListDrawer showingData={showingData24} {screenHeight} />
{/if}

<style>
  .details-wrapper {
    display: flex;
    flex-direction: column;
    height: 100%;
    overflow: auto;
    font-family: sans-serif;
    font-size: 14px;
    line-height: 18px;
    padding-right: 40px;
  }
</style>
