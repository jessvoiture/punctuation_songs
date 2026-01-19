<div class="body-text-wrapper">
  <div class="body-text">
    Historic Billboard Hot 100 data was sourced from <a
      href="https://github.com/utdata/rwd-billboard-data"
      target="_blank"
      rel="noopener noreferrer">UT-Austin School of Journalism and Media</a
    >. Songs only appear once, in the year they first entered the charts in an
    effort to better capture the era of a song.
  </div>

  <div class="body-text">
    Using the year a song first debuts on the chart is not always reflective of
    the year it was published. Songs may find chart success years after release.
  </div>

  <div class="body-text">
    The option to view the percent and number of songs per year is available, as
    the number of new songs entering the chart varies quite significantly
    throughout Billboard's history. Below is a chart of the number of new
    charting songs per year.
  </div>

  <img
    src="/count_songs_per_year.png"
    alt="A vertical bar chart showing the number of new songs entering the Billboard Hot 100 charts each year from 1958 to 2024. The trend has a U-shape: the number of songs peaks in the 1960s with over 700 new songs charting in the Hot 100, then declines, reaching a low of 288 in 2001. Since then early 2000s the number of new charting songs has generally increased. In 2024 there were 629 new songs entering the charts."
  />

  <div class="body-text">
    This project was built with svelte. All data analysis was done with R. You
    can find the code and data on <a
      href="https://github.com/jessvoiture/punctuation_songs"
      target="_blank">GitHub</a
    >. It was created by
    <a href="https://jessvoiture.github.io/home/" target="_blank">Jess Carr</a>.
    If you have feedback or questions, feel free to send me a message at
    <a href="mailto:someone@example.com">jessicascarr989@gmail.com</a>
    . Thank you so much for visiting!
  </div>

  <div class="body-text">Last updated 14 Jan 2026.</div>
</div>

<style>
  .body-text-wrapper {
    display: flex;
    flex-direction: column;
    gap: 24px;
  }
</style>
