<script>
  import { slide } from "svelte/transition";
  import { selectedOption, includeKeywordsParantheses } from "../../stores";
</script>

<div class={$selectedOption !== "parentheses" ? "hidden" : "visible"}>
  <label transition:slide>
    <input type="checkbox" bind:checked={$includeKeywordsParantheses} />
    Hide songs where parentheses are used for attribution, feature credit, or version
  </label>
</div>

<style>
  .hidden {
    opacity: 0;
    transition: opacity 0.3s ease-in-out;
  }

  .visible {
    opacity: 1;
    transition: opacity 0.3s ease-in-out;
  }
</style>
