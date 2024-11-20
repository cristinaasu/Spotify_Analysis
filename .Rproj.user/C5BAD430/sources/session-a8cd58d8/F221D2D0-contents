#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@utoronto.ca 
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(spotifyr)
library(readr)
library(dplyr)
library(tidyr)

#### Download Top 50 Canada Data ####
# Define the path to your folder containing the CSV files
folder_path <- "/Users/cristinasulam/Desktop/sta304/top50_daily/"

# Get a list of all CSV files in the folder
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Function to process each file
process_file <- function(file_path) {
  # Extract the date from the file name (assumes format like regional-ca-daily-YYYY-MM-DD.csv)
  date <- gsub(".*daily-([0-9]{4}-[0-9]{2}-[0-9]{2})\\.csv", "\\1", basename(file_path))
  
  # Read the file
  data <- read_csv(file_path)
  
  # Take the top 50 rows and add a date column
  data <- data %>%
    slice(1:50) %>%
    mutate(date = as.Date(date))
  
  return(data)
}

# Apply the function to all files and combine the results
top50_canada <- bind_rows(lapply(file_list, process_file))

write_csv(top50_canada, "data/01-raw_data/top50_canada.csv")

#### Test Fetch for a Single Observation ####
# Extract a single track ID from your dataset
test_track_id <- unique_tracks$track_id[1]  # Select the first track ID

# Function to fetch audio features for one track
fetch_single_audio_feature <- function(track_id) {
  tryCatch({
    Sys.sleep(1) # Ensure a delay to avoid throttling
    get_track_audio_features(track_id)
  }, error = function(e) {
    message(paste("Error fetching audio features for Track ID:", track_id))
    return(NULL) # Return NULL on failure
  })
}

# Fetch the audio features for the test track ID
test_audio_features <- fetch_single_audio_feature(test_track_id)

# View the results
if (!is.null(test_audio_features)) {
  print(test_audio_features)
} else {
  cat("Failed to fetch audio features for Track ID:", test_track_id, "\n")
}


# Save the enriched dataset
write_csv(top50_canada_enriched, "data/top50_canada_enriched.csv")

# Summary message
message("Audio features successfully merged for all valid tracks!")

#### Download Weather Data ####
# Define the path to your folder containing the weather CSV files
weather_folder_path <- "/Users/cristinasulam/Desktop/sta304/dailyweather"  

# Get a list of all CSV files in the folder
weather_file_list <- list.files(path = weather_folder_path, pattern = "*.csv", full.names = TRUE)

# Function to process each weather file
process_weather_file <- function(file_path) {
  # Read the file
  weather_data <- read_csv(file_path)
  
  # Add a column to identify the source file, if needed (optional)
  weather_data <- weather_data %>% mutate(Source_File = basename(file_path))
  
  return(weather_data)
}

# Apply the function to all files and combine the results
weather_data <- bind_rows(lapply(weather_file_list, process_weather_file))


#### Save data ####
write_csv(weather_data, "data/01-raw_data/weather_data.csv")

         
