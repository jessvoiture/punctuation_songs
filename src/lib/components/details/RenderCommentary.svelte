<script>
  import AudioPlay from "../AudioPlay.svelte";

  export let selectedInsight;
</script>

<div id="commentary" class="body-text">
  {#if selectedInsight.tldr ?? [].length > 0}
    <div id="tldr">
      <strong>TLDR</strong>
      <ul>
        {#each selectedInsight.tldr as li}
          <li>{li}</li>
        {/each}
      </ul>
    </div>
  {/if}

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

  #tldr {
    background-color: #f6f6f6;
    margin: 0 0 16px 0;
    padding: 12px 16px;
    border-radius: 4px;
  }

  ul {
    padding-left: 16px;
  }
</style>
