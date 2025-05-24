export const load = async ({ fetch }) => {
  const fetchData = async () => {
    const res = await fetch("/data/punctuation.json");
    if (!res.ok) {
      throw new Error("Failed to fetch punctuation data");
    }
    const data = await res.json();
    return data;
  };

  return {
    punctuation: await fetchData(),
  };
};
