#### Preamble ####
# Purpose: Process Spotify Top 50 and Weather data to create a clean, analysis-ready dataset.
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - Install required libraries: `tidyverse`, `arrow`.
# Any other information needed? None.

#### Workspace setup ####
library(tidyverse)
library(arrow)

#### Prepare Daily Weather data ####
# Load data
raw_weather <- read_csv("data/01-raw_data/weather_data.csv", show_col_types = FALSE)

# Extract City Names
raw_weather <- raw_weather %>%
  mutate(
    City = str_extract(`Station Name`, "^[^ ]+"), 
    City = if_else(City == "MCTAVISH", "MONTREAL", City)  
  )

# Add Population Data for Cities
city_population <- data.frame(
  City = c("TORONTO", "MONTREAL", "VANCOUVER", "CALGARY", "EDMONTON", "OTTAWA"),
  Population = c(6200000, 4200000, 2700000, 1600000, 1500000, 1400000)
)

raw_weather <- raw_weather %>%
  left_join(city_population, by = "City")

# Calculate Population-Weighted Daily Averages
average_daily_weather <- raw_weather %>%
  group_by(`Date/Time`) %>%
  summarize(
    avg_max_temp = weighted.mean(`Max Temp (°C)`, Population, na.rm = TRUE),
    avg_min_temp = weighted.mean(`Min Temp (°C)`, Population, na.rm = TRUE),
    avg_mean_temp = weighted.mean(`Mean Temp (°C)`, Population, na.rm = TRUE)
  )

# Rename Date Column
average_daily_weather <- average_daily_weather %>%
  rename(date = `Date/Time`)

#### Cleaning Analysis Dataset ####
# Merge Top 50 and Weather Cleaned Data
top50_features_data <-readRDS("data/01-raw_data/top50_features_data.rds")

merged_data_analysis <- top50_features_data %>%
  left_join(average_daily_weather, by = "date")

# Select and Rename Relevant Columns
analysis_data <- merged_data_analysis %>%
  select(
    artist_names, track_name, valence, avg_max_temp, avg_min_temp, avg_mean_temp, 
    danceability, acousticness, tempo, date
  ) %>%
  rename(
    Artist = artist_names,
    Song = track_name,
    Valence = valence,
    `Max Temp` = avg_max_temp,
    `Min Temp` = avg_min_temp,
    `Mean Temp` = avg_mean_temp,
    Danceability = danceability,
    Acousticness = acousticness,
    Tempo = tempo, 
    Date = date
  ) %>%
  mutate(
    `Scaled Mean Temp` = scale(`Mean Temp`),
    `Scaled Tempo` = scale(Tempo)
  )

# Check for missing values
missing_values <- analysis_data %>%
  summarise_all(~ sum(is.na(.)))

#### Save data ####
write_parquet(analysis_data, "data/02-analysis_data/analysis_data.parquet")
