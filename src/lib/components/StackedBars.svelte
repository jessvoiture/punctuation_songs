<script>
  import { tweened } from "svelte/motion";
  import { cubicInOut } from "svelte/easing";
  import { max } from "d3-array";
  import { selectedOption, selectedMetric } from "../../stores";
  import { onMount } from "svelte"; // No need for afterUpdate if reactive statement covers it

  export let xScale;
  export let yScale;
  export let showingData;
  export let innerWidth;
  export let innerHeight;
  export let maxSongsPerYear; // Unused in StackedBars if it's just drawing, but kept

  let canvas;
  let ctx;
  let rectWidth;

  // Debug 1: Ensure dimensions and rectWidth are valid early
  $: {
    console.log(
      "StackedBars Debug: innerWidth:",
      innerWidth,
      "innerHeight:",
      innerHeight,
    );
    rectWidth =
      innerWidth > 0 && showingData && showingData.length > 0
        ? innerWidth / showingData.length - 1
        : 0;
    console.log("StackedBars Debug: rectWidth:", rectWidth);
  }

  // Define a helper function to calculate the values
  function calculateTweenedValues(data, metric, innerHeight, yScale) {
    if (!data || data.length === 0 || !yScale || innerHeight === 0) {
      console.warn(
        "StackedBars Debug: calculateTweenedValues: Missing data or invalid dimensions/scales.",
      );
      return [];
    }

    let values;
    if (metric === "Number") {
      const countSongsPerYear = data.map((d) => d.count_with_punc);
      const maxValue = max(countSongsPerYear) || 1;
      values = data.map((d) => innerHeight / maxValue - 1);
    } else if (metric === "Percent") {
      values = data.map(
        (d) =>
          (innerHeight - yScale(d.percent_with_punc)) /
            (d.count_with_punc || 1) -
          1,
      );
    } else {
      // Fallback, perhaps unexpected metric value
      values = data.map((d) => innerHeight - yScale(d.percent_with_punc)); // Or some other sensible default
    }

    // Crucial validation: filter out non-finite numbers (NaN, Infinity)
    // If any of these calculations result in NaN or Infinity, it can break interpolation.
    const cleanedValues = values.map((v) => (Number.isFinite(v) ? v : 0)); // Replace non-finite with 0
    console.log(
      "StackedBars Debug: Calculated and cleaned values (first 5):",
      cleanedValues.slice(0, 5),
      "length:",
      cleanedValues.length,
    );
    return cleanedValues;
  }

  // Initialize tweenedY with a value based on current props
  // This runs when the component first mounts or its dependencies change
  const tweenedY = tweened(
    calculateTweenedValues(showingData, $selectedMetric, innerHeight, yScale),
    { duration: 500, easing: cubicInOut },
  );

  // Reactive block to update tweenedY when selectedMetric or showingData changes
  $: {
    console.log("StackedBars Debug: Reactive tweenedY update block triggered.");
    const currentCalculatedValues = calculateTweenedValues(
      showingData,
      $selectedMetric,
      innerHeight,
      yScale,
    );

    // Only set if the target values are actually different (deep comparison for arrays is expensive,
    // but a length check can quickly rule out obvious non-changes, or rely on tweened's internal check).
    // The `tweened` store usually handles this internally if the array reference is the same.
    // The main point is to ensure `currentCalculatedValues` is always an array of finite numbers.
    tweenedY.set(currentCalculatedValues);
    console.log("StackedBars Debug: tweenedY.set called.");
  }

  function drawBars() {
    console.log("StackedBars Debug: drawBars() called.");
    console.log(
      "StackedBars Debug: ctx ready:",
      !!ctx,
      "canvas ready:",
      !!canvas,
      "showingData present:",
      !!showingData,
      "tweenedY value present:",
      !!$tweenedY,
    );

    if (
      !ctx ||
      !canvas ||
      !showingData ||
      showingData.length === 0 ||
      !$tweenedY ||
      $tweenedY.length === 0
    ) {
      console.warn(
        "StackedBars Debug: drawBars() skipped due to missing essential data.",
      );
      return;
    }

    ctx.clearRect(0, 0, innerWidth, innerHeight);
    ctx.fillStyle = "#58b8db";

    showingData.forEach((datum, i) => {
      const currentTweenedYValue = $tweenedY[i];

      // Defensive check for currentTweenedYValue
      if (!Number.isFinite(currentTweenedYValue)) {
        console.warn(
          `StackedBars Debug: Skipping year ${datum.year} (index ${i}) due to non-finite currentTweenedYValue:`,
          currentTweenedYValue,
        );
        return; // Skip drawing for this year if value is bad
      }

      datum.songs.forEach((song, j) => {
        const x = xScale(datum.year);
        const height = song.empty ? 0 : currentTweenedYValue;
        const y = innerHeight - (currentTweenedYValue + 1) * (j + 1);

        // Debug: Check calculated bar parameters before drawing
        if (
          !Number.isFinite(x) ||
          !Number.isFinite(y) ||
          !Number.isFinite(rectWidth) ||
          !Number.isFinite(height)
        ) {
          console.error(
            `StackedBars Debug: Invalid bar parameters for year ${datum.year}, song ${j}: x=${x}, y=${y}, width=${rectWidth}, height=${height}`,
          );
          // Provide more detail for debugging:
          console.error({
            x,
            y,
            rectWidth,
            height,
            currentTweenedYValue,
            datumYear: datum.year,
            songIndex: j,
            datumPunc: datum.percent_with_punc,
            datumCount: datum.count_with_punc,
          });
          return; // Skip drawing this specific bar if parameters are bad
        }
        // console.log(`StackedBars Debug: Drawing bar for year ${datum.year}, song ${j}: x=${x}, y=${y}, width=${rectWidth}, height=${height}`); // Too chatty perhaps

        if (!song.empty && height > 0 && rectWidth > 0) {
          ctx.globalAlpha = 1;
          ctx.fillRect(x, y, rectWidth, height);
        }
      });
    });
  }

  onMount(() => {
    ctx = canvas.getContext("2d");
    console.log("StackedBars Debug: Canvas context obtained onMount:", ctx);
    // Ensure canvas dimensions are set correctly at least once.
    // Reactive block handles subsequent changes.
    if (canvas) {
      canvas.width = innerWidth;
      canvas.height = innerHeight;
    }
    drawBars(); // Initial draw on mount
  });

  // Main reactive block to trigger redraws
  $: {
    console.log("StackedBars Debug: Main redraw block triggered.");
    if (
      ctx &&
      $tweenedY &&
      showingData &&
      innerWidth > 0 &&
      innerHeight > 0 &&
      xScale &&
      yScale
    ) {
      if (canvas.width !== innerWidth || canvas.height !== innerHeight) {
        console.log(
          "StackedBars Debug: Resizing canvas:",
          innerWidth,
          innerHeight,
        );
        canvas.width = innerWidth;
        canvas.height = innerHeight;
      }
      drawBars();
    } else {
      console.warn(
        "StackedBars Debug: Main redraw block: Conditions not met.",
        {
          ctx,
          tweenedY: $tweenedY,
          showingData,
          innerWidth,
          innerHeight,
          xScale,
          yScale,
        },
      );
    }
  }
</script>

<canvas
  bind:this={canvas}
  width={innerWidth}
  height={innerHeight}
  style="display: block; background: none;"
></canvas>
