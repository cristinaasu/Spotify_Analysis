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
# then downloaded the daily weather data for each location. 
# This dataset can be found in data/01-raw_data/weather_data.csv [in this file I added all the 6 files together]

#### Save data ####
write_csv(top50_features_data, "data/02-analysis_data/top50_features_data.csv")