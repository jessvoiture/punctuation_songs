require(tidyverse)
require(dplyr)
require(ggplot2)
require(janitor)
require(stringr)
require(jsonlite)

years_which_might_be_in_paratheses <- as.character(1940:2024)

df <- read_csv("data/hot-100-current.csv") 

df <- df %>%
  mutate(parantheses_content = str_match(title, "\\(([^)]+)\\)")[,2]) %>%
  mutate(title = tolower(title),
         performer = tolower(performer)) %>%
  mutate(performer = case_match(
    performer,
    'nat "king" cole' ~ "nat king cole",
    .default = performer
  )) %>%
  mutate(title = case_match(
    title,
    "the children's marching song (nick nack taddy whack)" ~ "the children's marching song (nick nack paddy whack)",
    .default = title
  )) %>%
  group_by(title, performer) %>%
  filter(chart_week == min(chart_week)) %>%
  ungroup() %>%
  mutate(year = year(chart_week),
         month_year = as.Date(format(chart_week, "%Y-%m-01"))) %>%
  mutate(isDecember = if_else(month(chart_week) == 12, "December", "Not")) 

count_unique_songs_per_year <- df %>%
  group_by(year) %>%
  summarise(count_new_songs_in_year = n(), .groups = "drop_last") 

ggplot(count_unique_songs_per_year, aes(x = year, y = count_new_songs_in_year)) +
  geom_col() +
  theme_minimal() +
  labs(
    title = "New charting songs per year"
  )

with_paratheses <- df %>%
  filter(!is.na(parantheses_content)) %>%
  mutate(
    has_keywords = str_detect(
      str_to_lower(parantheses_content),
      "featuring|with|from|version|remix|theme|remastered|feat."
    ) | parantheses_content %in% years_which_might_be_in_paratheses
  ) %>%
  filter(!has_keywords) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

ggplot(with_paratheses, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with paratheses in them")

question <- df %>%
  filter(str_detect(title, "\\?")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

ggplot(question, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with ? in them")

exclamation <- df %>%
  filter(str_detect(title, "\\!")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

ggplot(exlamation, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with ! in them")

contractions <- df %>%
  filter(str_detect(title, "[a-zA-Z]+'[a-zA-Z]+")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

phonetic_elisions <- df %>%
  filter(str_detect(title, " '|' ")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

apostrophe <- df %>%
  filter(str_detect(title, "'")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

ggplot(contractions, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with contractions in them")

colon <- df %>%
  filter(str_detect(title, ":")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

ggplot(colon, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with : in them")

comma <- df %>%
  filter(str_detect(title, ",")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

ggplot(comma, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with comma in them")

period <- df %>%
  filter(str_detect(title, "\\.")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), fill = list(value = 0))

ggplot(period, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with : in them")


df_all_punctuation <- data.frame(
  year = c(1958:2025),
  parantheses_pct = with_paratheses$percent_with_punc, 
  exclamation_pct = exclamation$percent_with_punc,
  question_pct = question$percent_with_punc,
  apostrophe_pct = apostrophe$percent_with_punc,
  contraction_pct = contractions$percent_with_punc,
  phonetic_elision_pct = phonetic_elisions$percent_with_punc,
  period_pct = period$percent_with_punc
) %>%
  mutate(across(everything(), ~replace_na(., 0)))



# export ------------------------------------------------------------------

nested_df <- df_bb %>%
  group_by(year) %>%
  summarise(albums = list(data.frame(
    album, 
    album_release_date, 
    type, 
    first_album_release_date, 
    days_since_first_release, 
    days_since_last_release, 
    notes,
    album_image,
    artist_decade_debut,
    peak_pos,
    wks_on_chart,
    isBestAlbum,
    wks_on_chart_norm
  ))) %>%
  ungroup()

j <- toJSON(df_all_punctuation, pretty = TRUE)
cat(j)

write_json(df_all_punctuation, path = "punctuation.json", pretty = TRUE)
