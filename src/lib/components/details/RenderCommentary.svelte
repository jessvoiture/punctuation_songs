<script>
  import AudioPlay from "../AudioPlay.svelte";

  export let selectedInsight;
</script>

<div id="commentary" class="body-text">
  {#each selectedInsight.copy as part}
    {#if part.kind === "text"}
      <span>{@html part.value}</span>
    {:else if part.kind === "highlight"}
      <span
        style="background-color:#bee5f3; padding:1px 6px; border-radius:3px; -webkit-box-decoration-break: clone;
    box-decoration-break: clone;"
      >
        {part.value}
      </span>
    {:else if part.kind === "audio"}
      <AudioPlay src={part.src} song={part.song} />
    {/if}
  {/each}
</div>

<style>
  #commentary {
    color: #000000;
    font-size: 15px;
    line-height: 22px;
  }
</style>
