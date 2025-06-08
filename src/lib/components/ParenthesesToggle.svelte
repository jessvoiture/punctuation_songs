<script>
  import { slide } from "svelte/transition";
  import { selectedOption, includeKeywordsParantheses } from "../../stores";
</script>

{#if $selectedOption === "parentheses"}
  <label transition:slide>
    <input type="checkbox" bind:checked={$includeKeywordsParantheses} />
    Hide songs where parentheses are used for attribution, feature credit, or version
  </label>
{/if}
