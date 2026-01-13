require(tidyverse)
require(dplyr)
require(ggplot2)
require(janitor)
require(stringr)
require(jsonlite)


# read in data ------------------------------------------------------------


years_which_might_be_in_paratheses <- as.character(1940:2024)

df_raw <- read_csv("data/hot-100-current.csv") 

df <- df_raw %>%
  mutate(title_og = title,
         performer_og = performer) %>%
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
  group_by(title, title_og, performer, performer_og) %>%
  summarise(
    weeks_on_chart = max(wks_on_chart),
    debut_pos = first(current_week[order(chart_week)]),
    debut_week = min(chart_week),
    peak_pos = min(current_week),
    peak_pos_week = chart_week[which.min(current_week)],
    .groups = "drop"
  ) %>%
  mutate(year = year(debut_week),
         month_year = as.Date(format(debut_week, "%Y-%m-01"))) %>%
  mutate(title = str_replace_all(title, "\\.\\s*\\.\\s*\\.", "...")) %>%
  mutate(parantheses_content = str_match(title, "\\(([^)]+)\\)")[,2]) 


# general -----------------------------------------------------------------


count_unique_songs_per_year <- df %>%
  group_by(year) %>%
  summarise(count_new_songs_in_year = n(), .groups = "drop_last") 

ggplot(count_unique_songs_per_year %>% filter(year <= 2024), aes(x = year, y = count_new_songs_in_year)) +
  geom_col(fill = "#58b8db", alpha = 0.6) +
  theme_minimal() +
  # labs(
  #   title = "New charting songs per year"
  # ) +
  scale_y_continuous(
    breaks = c(0, 200, 400, 600),
    labels = c("0", "200", "400", "600"),
    # expand = c(0,0)
  ) +
  scale_x_continuous(
    expand = c(0.05,0),
    breaks = c(1960, 1980, 2000, 2020)
  ) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.title = element_blank(),
    axis.text.x = element_text(margin = margin(0,0,0,0)),
    axis.ticks.length = unit(0, "cm"),
    text = element_text(size = 24, color = "black")
  )

song_length <- df %>%
  mutate(song_char_count = str_count(title_og)) %>%
  group_by(year) %>%
  summarise(avg_song_length = mean(song_char_count))

ggplot(song_length, aes(x = year, y = avg_song_length)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Average song length in characters")


# punc --------------------------------------------------------------------


parantheses <- df %>%
  filter(!is.na(parantheses_content)) %>%
  mutate(type = "parentheses")
  
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
             type = "parentheses")) %>%
  select(year, type, count_with_punc, percent_with_punc) 

ggplot(parantheses_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with paratheses in them")

parantheses_no_keywords <- parantheses %>%
  mutate(parantheses_content = str_match(title, "\\(([^)]+)\\)")[,2]) %>%
  mutate(
    has_keywords = str_detect(
      str_to_lower(parantheses_content),
      "featuring|with|from|version|remix|theme|remastered|feat."
    ) | parantheses_content %in% years_which_might_be_in_paratheses
  ) %>%
  filter(!has_keywords) %>%
  mutate(type = "parantheses_no_keywords") %>%
  select(-has_keywords)

parantheses_no_keywords_pct <- parantheses_no_keywords %>%
  group_by(year, type) %>%
  summarise(count_with_punc = n()) %>%
  ungroup() %>%
  left_join(count_unique_songs_per_year, by = "year") %>%
  mutate(percent_with_punc = count_with_punc / count_new_songs_in_year * 100) %>%
  complete(year = full_seq(1958:2025, 1), 
           fill = list(
             percent_with_punc = 0, 
             count_with_punc = 0,
             type = "parantheses_no_keywords")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(parantheses_no_keywords_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with paratheses in them")


question <- df %>%
  filter(str_detect(title, "\\?")) %>%
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
  mutate(type = "exclamation")

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
  # filter(str_detect(title, "taylor's")) %>%
  mutate(type = "apostrophe") 
  # group_by(year) %>%
  # summarise(count = n())

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
             type = "colons")) %>%
  select(year, type, count_with_punc, percent_with_punc)

ggplot(colon_pct, aes(x = year, y = percent_with_punc)) +
  geom_col() +
  theme_minimal() +
  labs(title = "Billboard charting songs with : in them")

comma <- df %>%
  filter(str_detect(title, ",")) %>%
  mutate(type = "comma") 
  # group_by(performer) %>%
  # summarise(count= n())
  # separate_wider_delim(title, delim = ",", names = c("first", "second"), too_many = "drop") %>%
  # mutate_all(str_trim) %>%
  # mutate(repeats = first == second) %>%
  # group_by(year) %>%
  # summarise(
  #   count = sum(repeats, na.rm = TRUE),
  #   total = n(),
  #   percent = 100 * count / total
  # )

 
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
  mutate(type = "period") 
  # mutate(contains_usa = str_detect(title, "U\\.S\\.A\\."))

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

amper <- df %>%
  filter(str_detect(title, "\\&")) %>%
  # filter(str_detect(title, " and ")) %>%
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
  filter(str_detect(title, "\\$")) %>%
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
  filter(str_detect(title, "[-–—]")) %>%
  # filter(!(str_detect(title, "- part") | str_detect(title, "- pt") 
  #        | str_detect(title, "-pt") | str_detect(title, "-part"))) %>%
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
  # select(title, performer, title_og, performer_og, chart_week, year) %>%
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
  mutate(title_og = str_replace(title_og, "\\.\\s*\\.\\s*\\.", "...")) %>%
  filter(str_detect(title, fixed('...'))) %>%
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

swears <- df %>%
  filter(str_detect(title, "u\\.s\\.a\\."))
  # select(title, performer, title_og, performer_og, chart_week, year) %>%

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


# put it all together -----------------------------------------------------


df_all_punctuation <- data.frame(
  year = c(1958:2025),
  parantheses_pct = parantheses_pct$percent_with_punc, 
  parantheses_no_keywords_pct = parantheses_no_keywords_pct$percent_with_punc,
  exclamation_pct = exclamation_pct$percent_with_punc,
  question_pct = question_pct$percent_with_punc,
  apostrophe_pct = apostrophe_pct$percent_with_punc,
  period_pct = period_pct$percent_with_punc,
  comma_pct = comma_pct$percent_with_punc,
  # usd_pct = usd_pct$percent_with_punc,
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
  parantheses, parantheses_no_keywords, exclamation, question, apostrophe, 
  period, comma, amper, dash, slash, 
  asterisk, quote, colon, ellipses
)

df_pcts <- rbind(
  parantheses_pct, parantheses_no_keywords_pct, exclamation_pct, question_pct, apostrophe_pct,
  period_pct, comma_pct, amper_pct, dash_pct, slash_pct,
  asterisk_pct, quote_pct, colon_pct, ellipses_pct
)

df_all <- df_pcts %>%
  left_join(df_songs, by =c("year", "type"))

nested_json <- df_all %>%
  group_by(type, year, count_with_punc, percent_with_punc) %>%
  summarise(
    songs = list(
      lapply(seq_along(title), function(i) list(
        title = unbox(title[i]),
        performer = unbox(performer[i]),
        title_og = unbox(title_og[i]),
        performer_og = unbox(performer_og[i]),
        debut_week = unbox(debut_week[i]),
        debut_pos = unbox(debut_pos[i]),
        peak_pos_week = unbox(peak_pos_week[i]),
        peak_pos = unbox(peak_pos[i]),
        weeks_on_chart = unbox(weeks_on_chart[i])
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

write_json(nested_json, path = "punctuation_songs_2.json", pretty = TRUE, auto_unbox = TRUE)



# facets ------------------------------------------------------------------

df_long <- df_all_punctuation %>%
  pivot_longer(
    cols = contains("pct"),
    values_to = "pct",
    names_to = "punc"
  ) %>%
  mutate(punc = str_remove(punc, "_pct")) %>%
  mutate(punc = recode(
    punc,
    "parantheses_no_keywords" = "Parentheses*",
    "exclamation" = "exclamation mark",
    "question" = "question mark",
    "quote" = "quatation marks"
  )) %>%
  filter(punc != "parantheses", punc != "amper") %>%
  mutate(punc = str_to_title(punc)) %>%
  mutate(punc = factor(punc, levels = c(
    "Parentheses*", "Asterisk", 'Slash', "Dash", 
    "Comma", "Quatation Marks",  "Apostrophe", "Period",  
    "Question Mark","Exclamation Mark", "Ellipses", "Colon"
  )))

ggplot(df_long, aes(x = year, y = pct)) +
  geom_col(fill = "#58b8db", alpha = 0.7, width = 0.95) +
  facet_wrap(~punc, ncol = 4, scales = "free_y") +
  theme_minimal() +
  scale_y_continuous(
    labels = function(x) paste0(x, "%"),
    expand = c(0,0)
  ) +
  scale_x_continuous(
    breaks = c(1960, 1980, 2000, 2020),
    expand = c(0,0)
  ) +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.text.x = element_text(hjust = 0),
    strip.text = element_text(face = "bold"),
    axis.title = element_blank(),
    panel.spacing.x = unit(2, "lines"),
    panel.spacing.y = unit(2, "lines"),
    plot.title = element_text(
      hjust = -0.5,                 
      margin = margin(l = 0)      
    )
  ) +
  labs(
    title = "Prevalence of punctuation marks in song titles over time",
    subtitle = "Yearly percent of new entries on the Billboard Hot 100",
    caption = "* excludes songs which use parentheses for film attribution, feature credit, or version"
  )
