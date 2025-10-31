<script>
  import { onMount } from "svelte";
  import { isPlaying, spotifyCurrentTrack } from "../../stores";
  import { playUri, pause, resume, getController } from "../../lib/spotify";

  export let spotifyUri; // track id, e.g. "7iN1s7xHE4ifF5povM6A48"
  export let name;

  // Derived: true if this component's uri is the current playing track
  $: isThisTrack = $spotifyCurrentTrack === spotifyUri;
  $: isThisPlaying = isThisTrack && $isPlaying;

  async function handlePlayPause() {
    // if clicking the currently selected track
    if ($spotifyCurrentTrack === spotifyUri) {
      if ($isPlaying) {
        pause();
        isPlaying.set(false);
      } else {
        resume();
        isPlaying.set(true);
      }
      return;
    }

    // different track requested: play it
    // pause any previous controller first (playUri does that)
    await playUri(spotifyUri);
    spotifyCurrentTrack.set(spotifyUri);
    isPlaying.set(true);
  }
</script>

<!-- svelte-ignore a11y_invalid_attribute -->
<a
  href="#"
  class="btn-wrapper"
  class:playing={isThisPlaying}
  role="button"
  tabindex="0"
  on:click={(e) => {
    e.preventDefault();
    handlePlayPause();
  }}
  on:keydown={(e) =>
    (e.key === "Enter" || e.key === " ") &&
    (e.preventDefault(), handlePlayPause())}
  aria-pressed={isThisPlaying}
  aria-label={isThisPlaying ? "Pause" : "Play"}
>
  {name}
  <i class="material-icons" aria-hidden="true">
    {isThisPlaying ? "pause" : "play_arrow"}
  </i>
</a>

<style>
  .btn-wrapper {
    display: inline;
    align-items: center;
    justify-content: center;
    border-radius: 3px;
    background: #ceecf7;
    cursor: pointer;
    vertical-align: baseline; /* wraps with text */
    text-decoration: none; /* remove link underline */
    color: #000;
    padding-left: 6px;
    padding-right: 6px;
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

  .playing,
  .playing:hover {
    background: #71d8fb;
  }
</style>
