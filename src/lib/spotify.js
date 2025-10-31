let apiPromise;
let iframeApi;
let controller = null;

// ensure the Spotify iframe API is loaded and available
function ensureApiLoaded() {
  if (apiPromise) return apiPromise;

  apiPromise = new Promise((resolve) => {
    if (window.onSpotifyIframeApiReady && window.SpotifyIframe) {
      resolve(window.SpotifyIframe);
      return;
    }

    const script = document.createElement("script");
    script.src = "https://open.spotify.com/embed/iframe-api/v1";
    script.async = true;
    document.body.appendChild(script);

    window.onSpotifyIframeApiReady = (iframeApiArg) => {
      resolve(iframeApiArg);
    };
  });

  return apiPromise;
}

// create a controller for a given track URI (spotify track id)
// this recreates the controller in the hidden #embed-iframe container
export async function playUri(spotifyId) {
  iframeApi = await ensureApiLoaded();

  try {
    controller?.pause();
  } catch (e) {}

  // ensure an embed container exists (create one if missing)
  let element = document.getElementById("embed-iframe");
  if (!element) {
    element = document.createElement("div");
    element.id = "embed-iframe";
    element.style.display = "none";
    element.style.visibility = "hidden";
    element.setAttribute("aria-hidden", "true");
    document.body.appendChild(element);
  }

  return new Promise((resolve) => {
    const options = {
      width: "100%",
      height: "0",
      uri: `spotify:track:${spotifyId}`,
    };

    iframeApi.createController(element, options, (ctrl) => {
      controller = ctrl;
      try {
        controller.resume();
      } catch (e) {
        setTimeout(() => controller.resume && controller.resume(), 100);
      }
      resolve(controller);
    });
  });
}

export function pause() {
  try {
    controller?.pause();
  } catch (e) {}
}

export function resume() {
  try {
    controller?.resume();
  } catch (e) {}
}

export function getController() {
  return controller;
}
