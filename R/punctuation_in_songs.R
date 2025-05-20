require(tidyverse)
require(dplyr)
require(ggplot2)
require(janitor)
require(stringr)

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
  geom_col()

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
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100)

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
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100)

ggplot(question, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with ? in them")

exlamation <- df %>%
  filter(str_detect(title, "\\!")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100)

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
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100)

phonetic_elisions <- df %>%
  filter(str_detect(title, " '|' ")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100)

apostrophe <- df %>%
  filter(str_detect(title, "'")) %>%
  group_by(year) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100)

ggplot(contractions, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with apostrophes in them")



