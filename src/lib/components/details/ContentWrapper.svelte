<script>
  import { selectedOption, includeKeywordsParantheses } from "../../../stores";
  import Content from "./Content.svelte";
  import DrawerMobile from "./DrawerMobile.svelte";
  import Tabs from "./Tabs.svelte";

  export let screenHeight;
  export let screenWidth;
  export let data;
  export let isMobile;

  let showingData = data.find((d) => d.type === "parentheses")?.years || [];
  let showingData24 = showingData.filter((d) => Number(d.year) <= 2024);

  $: if ($includeKeywordsParantheses && $selectedOption === "parentheses") {
    showingData24 =
      data.find((item) => item.type === "parantheses_no_keywords")?.years || [];
  } else {
    showingData24 = data.find((d) => d.type === $selectedOption)?.years || [];
  }
</script>

<div class="details-wrapper">
  {#if !isMobile}
    <Tabs {isMobile} />
    <Content showingData={showingData24} {screenWidth} {isMobile} />
  {:else if isMobile}
    <DrawerMobile
      showingData={showingData24}
      {screenHeight}
      {screenWidth}
      {isMobile}
    />
  {/if}
</div>

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
