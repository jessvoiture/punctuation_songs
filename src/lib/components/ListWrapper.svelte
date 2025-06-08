<script>
  import { selectedOption, includeKeywordsParantheses } from "../../stores";
  import List from "./List.svelte";
  import ListDrawer from "./ListDrawer.svelte";

  export let screenHeight;
  export let screenWidth;
  export let data;

  let showingData = data.find((d) => d.type === "parentheses")?.years || [];
  $: if ($includeKeywordsParantheses && $selectedOption === "parentheses") {
    showingData =
      data.find((item) => item.type === "parantheses_no_keywords")?.years || [];
  } else {
    showingData = data.find((d) => d.type === $selectedOption)?.years || [];
  }
</script>

{#if screenWidth >= 860}
  <List {showingData} {screenWidth} />
{:else if screenWidth < 860}
  <ListDrawer {showingData} {screenHeight} />
{/if}
