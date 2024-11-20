#### Preamble ####
# Purpose: Process Spotify Top 50 and Weather data to create a clean, analysis-ready dataset.
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - Install required libraries: `tidyverse`, `spotifyr`, `readr`, `dplyr`, `stringr`.
#   - Obtain a Spotify API key and set it up in your `.Renviron` file with the following variables:
#       SPOTIFY_CLIENT_ID = 'YOUR_CLIENT_ID'
#       SPOTIFY_CLIENT_SECRET = 'YOUR_CLIENT_SECRET'
# Any other information needed? Script includes fetching Spotify audio features via Spotify API 
                               #and calculating population-weighted daily weather averages for analysis.

#### Workspace setup ####
library(tidyverse)
library(spotifyr)
library(readr)
library(dplyr)
library(stringr)

#### Prepare Top 50 Data ####
# Load data
raw_top50 <- read.csv("data/01-raw_data/top50_canada.csv")

# Extract the numerical part of the URI
raw_top50 <- raw_top50 %>%
  mutate(uri_numeric = gsub("spotify:track:", "", uri))

# Select only the unique URIs
unique_uris <- unique(raw_top50$uri_numeric)

# Initialize an empty list to store the features
audio_features_list <- list()

# Fetch audio features for each unique URI
for (uri in unique_uris) {
  tryCatch({
    features <- get_track_audio_features(uri)
    audio_features_list[[uri]] <- features
  }, error = function(e) {
    message(paste("Error fetching data for URI:", uri))
  })
  Sys.sleep(0.5)
}

# Combine all the fetched audio features into a single data frame
audio_features_df <- bind_rows(audio_features_list, .id = "uri_numeric")

# Merge the audio features back to the original dataset using uri_numeric
top50_features_data <- raw_top50 %>%
  left_join(audio_features_df, by = "uri_numeric")

#### Prepare Daily Weather data ####
# Load data
raw_weather <- read_csv("data/01-raw_data/weather_data.csv")

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
merged_data_analysis <- top50_features_data %>%
  left_join(average_daily_weather, by = "date")

# Select and Rename Relevant Columns
analysis_data <- merged_data_analysis %>%
  select(
    artist_names, track_name, valence, avg_max_temp, avg_min_temp, avg_mean_temp, 
    danceability, energy, acousticness, tempo, date
  ) %>%
  rename(
    Artist = artist_names,
    Song = track_name,
    Valence = valence,
    `Max Temp` = avg_max_temp,
    `Min Temp` = avg_min_temp,
    `Mean Temp` = avg_mean_temp,
    Danceability = danceability,
    Energy = energy,
    Acousticness = acousticness,
    Tempo = tempo, 
    Date = date
  )

# Check for missing values
missing_values <- analysis_data %>%
  summarise_all(~ sum(is.na(.)))

#### Save data ####
write_csv(top50_features_data, "data/02-analysis_data/top50_features_data.csv")
write_csv(average_daily_weather, "data/02-analysis_data/average_daily_weather.csv")
write_csv(analysis_data, "data/02-analysis_data/analysis_data.csv")
