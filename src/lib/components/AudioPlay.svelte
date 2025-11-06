<script>
  import { onDestroy } from "svelte";
  import { currentAudio, selectedOption } from "../../stores";

  export let src;
  export let song;

  console.log(src);

  let audio;
  let isPlaying = false;
  let progress = 0;
  let duration = 0;
  let rafId;

  function toggle() {
    if (!audio) return;
    if (audio.paused) {
      currentAudio.set(audio);
      audio.play();
    } else {
      audio.pause();
    }
  }

  function update() {
    if (!audio) return;
    progress = duration ? audio.currentTime / duration : 0;
    rafId = requestAnimationFrame(update);
  }

  function onPlay() {
    isPlaying = true;
    duration = audio.duration || 0;
    cancelAnimationFrame(rafId);
    update();
  }

  function onPause() {
    isPlaying = false;
    cancelAnimationFrame(rafId);

    // if this was the active one, clear the store
    if ($currentAudio === audio) {
      currentAudio.set(null);
    }
  }

  function onEnded() {
    isPlaying = false;
    progress = 1;
    cancelAnimationFrame(rafId);

    if ($currentAudio === audio) {
      currentAudio.set(null);
    }
  }

  $: if ($currentAudio && $currentAudio !== audio) {
    if (!audio.paused) {
      audio.pause();
    }
  }

  onDestroy(() => {
    // if this component is unmounted, stop the audio
    if (audio) {
      audio.pause();
    }
    // clear the store if it points to this audio
    if ($currentAudio === audio) {
      currentAudio.set(null);
    }
  });
</script>

<audio
  bind:this={audio}
  src={`/songs/${src}`}
  preload="metadata"
  on:play={onPlay}
  on:pause={onPause}
  on:ended={onEnded}
></audio>

<!-- svelte-ignore a11y_missing_attribute -->
<a
  class="btn-wrapper"
  class:is-playing={isPlaying}
  role="button"
  tabindex="0"
  on:click={toggle}
  on:keydown={(e) =>
    (e.key === "Enter" || e.key === " ") && (e.preventDefault(), toggle())}
  aria-label={isPlaying ? "Pause" : "Play"}
>
  {song}

  <i class="material-icons">{isPlaying ? "pause" : "play_arrow"}</i>
</a>

<style>
  .btn-wrapper {
    display: inline;
    align-items: center;
    justify-content: center;
    border-radius: 6px;
    background: #ceecf7;
    cursor: pointer;
    vertical-align: baseline; /* wraps with text */
    text-decoration: none; /* remove link underline */
    color: #000;
    padding: 1px 6px;
    -webkit-box-decoration-break: clone;
    box-decoration-break: clone;
  }

  .btn-wrapper:hover {
    background: #a4e3f9;
  }

  .material-icons {
    font-size: 18px;
    line-height: 1;
    vertical-align: text-bottom;
  }

  .is-playing,
  .is-playing:hover {
    background: #71d8fb;
  }
</style>
