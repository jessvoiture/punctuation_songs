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
         month_year = as.Date(format(chart_week, "%Y-%m-01")))

count_unique_songs_per_year <- df %>%
  group_by(year) %>%
  summarise(count_new_songs_in_year = n(), .groups = "drop_last") 

ggplot(count_unique_songs_per_year, aes(x = year, y = count_new_songs_in_year)) +
  geom_col() +
  theme_minimal() +
  labs(
    title = "New charting songs per year"
  )

parantheses <- df %>%
  filter(!is.na(parantheses_content)) %>%
  mutate(
    has_keywords = str_detect(
      str_to_lower(parantheses_content),
      "featuring|with|from|version|remix|theme|remastered|feat."
    ) | parantheses_content %in% years_which_might_be_in_paratheses
  ) %>%
  filter(!has_keywords) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "parantheses")
  
parantheses_pct <- parantheses %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "parantheses")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(parantheses_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with paratheses in them")

question <- df %>%
  filter(str_detect(title, "\\?")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "question")

question_pct <- question %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "question")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(question_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with ? in them")

exclamation <- df %>%
  filter(str_detect(title, "\\!")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "exlamation")

exclamation_pct <- exclamation %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "exclamation")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(exclamation_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with ! in them")

apostrophe <- df %>%
  filter(str_detect(title, "'")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "apostrophe")

apostrophe_pct <- apostrophe %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "apostrophe")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(apostrophe_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with contractions in them")

colon <- df %>%
  filter(str_detect(title, ":") | str_detect(title, ";")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "colons")

colon_pct <- colon %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "colon")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(colon_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with : in them")

comma <- df %>%
  filter(str_detect(title, ",")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "comma")
 
comma_pct <- comma %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "comma")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(comma_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with comma in them")

period <- df %>%
  filter(str_detect(title, "\\.")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "period")

period_pct <- period %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "period")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(period_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with . in them")

usd <- df %>%
  filter(str_detect(title, "\\$")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "usd")

usd_pct <- usd %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "usd")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(usd_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with $ in them")

amper <- df %>%
  filter(str_detect(title, "\\&")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "ampersand")

amper_pct <- amper %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "ampersand")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(amper_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with & in them")

hash <- df %>%
  filter(str_detect(title, "#")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "hash")

hash_pct <- hash %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "hash")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(hash_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with # in them")

dash <- df %>%
  filter(str_detect(title, "-")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "dash")

dash_pct <- dash %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "dash")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(dash_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with - in them")

slash <- df %>%
  filter(str_detect(title, "/")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "slash")

slash_pct <- slash %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "slash")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(slash_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with / in them")

asterisk <- df %>%
  filter(str_detect(title, "\\*")) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "asterisk")

asterisk_pct <- asterisk %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "asterisk")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(asterisk_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with * in them")

quote <- df %>%
  filter(str_detect(title, '"')) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "quote")

quote_pct <- quote %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "quote")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(quote_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = 'Billboard charting songs with " in them')

ellipses <- df %>%
  filter(str_detect(title, fixed('...'))) %>%
  select(title, performer, chart_week, year) %>%
  mutate(type = "ellipses")

ellipses_pct <- ellipses %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "ellipses")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(ellipses_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = 'Billboard charting songs with ... in them')

df_all_punctuation <- data.frame(
  year = c(1958:2025),
  parantheses_pct = parantheses_pct$percent_with_punc, 
  exclamation_pct = exclamation_pct$percent_with_punc,
  question_pct = question_pct$percent_with_punc,
  apostrophe_pct = apostrophe_pct$percent_with_punc,
  period_pct = period_pct$percent_with_punc,
  comma_pct = comma_pct$percent_with_punc,
  usd_pct = usd_pct$percent_with_punc,
  amper_pct = amper_pct$percent_with_punc,
  dash_pct = dash_pct$percent_with_punc,
  slash_pct = slash_pct$percent_with_punc,
  asterisk_pct = asterisk_pct$percent_with_punc,
  quote_pct = quote_pct$percent_with_punc,
  colon_pct = colon_pct$percent_with_punc,
  ellipses_pct = ellipses_pct$percent_with_punc
) %>%
  mutate(across(everything(), ~replace_na(., 0)))

df_songs <- rbind(
  parantheses, exclamation, question, apostrophe, 
  period, comma, usd, amper, dash, slash, 
  asterisk, quote, colon, ellipses
)

df_pcts <- rbind(
  parantheses_pct, exclamation_pct, question_pct, apostrophe_pct,
  period_pct, comma_pct, usd_pct, amper_pct, dash_pct, slash_pct,
  asterisk_pct, quote_pct, colon_pct, ellipses_pct
)

df_all <- df_songs %>%
  left_join(df_pcts, by =c("year", "type"))

nested_df <- df_all %>%
  group_by(year, type, count_with_punc, percent_with_punc) %>%
  summarise(songs = list(data.frame(
    title, performer, chart_week
  ))) %>%
  ungroup()

nested_json <- df_all %>%
  group_by(type, year, count_with_punc, percent_with_punc) %>%
  summarise(
    songs = list(
      lapply(seq_along(title), function(i) list(
        title = unbox(title[i]),
        performer = unbox(performer[i]),
        chart_week = unbox(chart_week[i])
      ))
    ),
    .groups = "drop"
  ) %>%
  group_by(type) %>%
  summarise(
    years = list(
      lapply(seq_along(year), function(i) list(
        year = unbox(year[i]),
        percent_with_punc = unbox(percent_with_punc[i]),
        count_with_punc = unbox(count_with_punc[i]),
        songs = songs[[i]]
      ))
    ),
    .groups = "drop"
  )


# export ------------------------------------------------------------------


write_json(nested_json, path = "punctuation_songs.json", pretty = TRUE, auto_unbox = TRUE)
