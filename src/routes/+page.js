export const load = async ({ fetch }) => {
  const fetchSongs = async () => {
    const res = await fetch("/data/punctuation_songs.json");
    if (!res.ok) {
      throw new Error("Failed to fetch punctuation song data");
    }
    const data = await res.json();
    return data;
  };

  return {
    songs: await fetchSongs(),
  };
};
