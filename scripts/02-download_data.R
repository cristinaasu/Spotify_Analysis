#### Preamble ####
# Purpose: Integration of Spotify's Top 50 audio features through the Spotify API into a single dataset. 
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - Install required libraries: `tidyverse`, `spotifyr`, `arrow`.
#   - Obtain a Spotify API key through https://developer.spotify.com/documentation/web-api 
#     and set it up in your `.Renviron` file with the following variables:
#       SPOTIFY_CLIENT_ID = 'YOUR_CLIENT_ID'
#       SPOTIFY_CLIENT_SECRET = 'YOUR_CLIENT_SECRET'
# Any other information needed? None.

#### Workspace setup ####
library(tidyverse)
library(spotifyr)
library(arrow)

#### Obtain Top 50 Data Features ####
# Load data
# I downloaded the Daily Top Songs in Canada from Spotify Charts Website 
# (https://charts.spotify.com/charts/view/regional-global-daily/latest) 
# and save them into one folder `dailytop_songs` under data.
data_dir <- "data/01-raw_data/dailytop_songs"

# List all CSV files in the directory
csv_files <- list.files(data_dir, pattern = "\\.csv$", full.names = TRUE)

# Function to read and filter each CSV file
read_and_filter <- function(file) {
  # Read the file
  df <- read.csv(file)
  
  # Filter to include only the Top 50 songs (assuming a 'Rank' column exists)
  df <- df %>% filter(rank <= 50)
  
  # Add a column for the date (assuming the filename includes the date)
  df$date <- gsub(".*([0-9]{4}-[0-9]{2}-[0-9]{2}).*", "\\1", basename(file))
  
  return(df)
}

# Apply the function to all files and combine the results
raw_top50 <- lapply(csv_files, read_and_filter) %>% bind_rows()

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

# Merge the audio features with the original Top 50 data using the unique Spotify track URIs
# The `date` column is converted to Date format 
top50_features_data <- raw_top50 %>%
  left_join(audio_features_df, by = "uri_numeric") %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))

# Save using saveRDS to ensure it retains its exact structure and type for reloading in future R sessions.
saveRDS(top50_features_data, "data/01-raw_data/top50_features_data.rds")

#### Obtain Weather Data ####
# To obtain the daily weather data for the cities of Toronto, Montreal, Edmonton, Calgary, 
# Ottawa, and Vancouver, I navigated to the Government of Canada's Climate Weather website. 
# On the site, I accessed the historical data search page at https://climate.weather.gc.ca/historical_data/search_historic_data_e.html, 
# where I used the "Search by Proximity" feature to select each city individually. 
# For each city, I set the date range to cover the year 2024 and chose the "daily" data interval. 
# Specific weather stations were selected based on their relevance and proximity to city centers: 
# "VANCOUVER HARBOUR CS" for Vancouver, "EDMONTON BLATCHFORD" for Edmonton, 
# "CALGARY INT'L CS" for Calgary, "OTTAWA CDA RCS" for Ottawa, "TORONTO CITY" for Toronto, 
# and "MCTAVISH" for Montreal. After configuring the settings, I executed the search by clicking "Go", 
# then downloaded the daily weather data for each location and save them in one folder `dailyweather`under data.

# Define the directory containing weather data files
weather_data_dir <- "data/01-raw_data/dailyweather"

# List all CSV files in the directory
weather_files <- list.files(weather_data_dir, pattern = "\\.csv$", full.names = TRUE)

# Function to read and standardize each weather file
read_weather_data <- function(file) {
  # Read the file
  df <- read.csv(file, check.names = FALSE)
  
  # Add a column for the city (assuming city name is in the filename)
  df$city <- gsub(".*([A-Za-z]+)_weather.*", "\\1", basename(file))
  
  # Return the data frame
  return(df)
}

# Apply the function to all files and combine the results
weather_data <- lapply(weather_files, read_weather_data) %>% bind_rows()

#### Save data ####
write_csv(top50_features_data, "data/01-raw_data/top50_features_data.csv")
write.csv(weather_data, "data/01-raw_data/weather_data.csv", row.names = FALSE)