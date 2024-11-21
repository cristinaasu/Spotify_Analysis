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
# Any other information needed? Script includes fetching Spotify audio features via Spotify API.

#### Workspace setup ####
library(tidyverse)
library(spotifyr)
library(arrow)

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

# Merge the audio features with the original Top 50 data using the unique Spotify track URIs
# The `date` column is converted to Date format 
top50_features_data <- raw_top50 %>%
  left_join(audio_features_df, by = "uri_numeric") %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))

# Save the combined dataset with audio features
saveRDS(top50_features_data, "top50_features_data.rds")

#### Save data ####
write_csv(top50_features_data, "data/02-analysis_data/top50_features_data.csv")