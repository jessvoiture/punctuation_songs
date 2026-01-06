<script>
  import AudioPlay from "../AudioPlay.svelte";

  export let selectedInsight;
</script>

<div id="commentary" class="body-text">
  {#if selectedInsight.tldr ?? [].length > 0}
    <div id="tldr">
      <strong>Overview</strong>
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
    {:else if part.kind === "image"}
      <div class="image-container {part.direction || 'row'}">
        {#each part.images as img}
          <div class="image-wrapper">
            <p>{@html img.caption}</p>
            <img
              class={img.class ? img.class : "half-width"}
              src={img.src}
              alt={img.alt}
            />
          </div>
        {/each}
      </div>
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
    padding: 16px 16px;
    border-radius: 4px;
  }

  ul {
    padding-left: 16px;
  }

  li:not(:last-child) {
    margin-bottom: 8px;
  }

  .image-container {
    display: flex;
    gap: 8px;
    margin-bottom: 24px;
  }

  .image-wrapper {
    display: flex;
    flex-direction: column;
    gap: 4px;
    width: 100%;
  }

  .column {
    flex-direction: column;
    gap: 24px;
  }

  .image-wrapper {
    width: 100%;
    height: auto;
    object-fit: contain;
  }

  p {
    margin: 0px;
    color: #757575;
    font-style: italic;
  }
</style>
