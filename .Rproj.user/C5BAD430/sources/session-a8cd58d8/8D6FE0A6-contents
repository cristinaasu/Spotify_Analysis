#### Preamble ####
# Purpose: Tests the structure and validity of the simulated dataset.
# Author: Cristina Su Lam
# Date: 18 November 2024
# Contact: cristina.sulam@utoronto.ca
# License: MIT
# Pre-requisites: 00-simulate_data.R must have been run.
# Any other information needed? None.


#### Workspace setup ####
library(tidyverse)

analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check if the dataset has 1690 rows (as there are 10 songs per day and 169 days)
expected_rows <- 1690
if (nrow(simulated_data) == expected_rows) {
  message("Test Passed: The dataset has the correct number of rows.")
} else {
  stop(paste("Test Failed: The dataset does not have", expected_rows, "rows."))
}

# Check if the dataset has 8 columns (date, track_name, artist, valence, temperature, danceability, energy, acousticness, tempo)
expected_columns <- c("date", "track_name", "artist", "valence", "temperature", "danceability", "energy", "acousticness", "tempo")
if (all(names(simulated_data) %in% expected_columns)) {
  message("Test Passed: The dataset has the correct columns.")
} else {
  stop("Test Failed: The dataset does not have the correct columns.")
}

# Check if all values in the 'track_name' column are valid song names
valid_songs <- c(
  "This is me trying", "Fearless", "About you", "Robbers", "Free Now",
  "Close to you", "Sparks", "Paradise", "Little Things", "Right Now"
)

if (all(simulated_data$track_name %in% valid_songs)) {
  message("Test Passed: The 'track_name' column contains only valid song names.")
} else {
  stop("Test Failed: The 'track_name' column contains invalid song names.")
}

# Check if all values in the 'artist' column are valid artist names
valid_artists <- c(
  "Taylor Swift", "The 1975", "Gracie Abrams", "Coldplay", "One Direction"
)

if (all(simulated_data$artist %in% valid_artists)) {
  message("Test Passed: The 'artist' column contains only valid artist names.")
} else {
  stop("Test Failed: The 'artist' column contains invalid artist names.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if valence, temperature, danceability, energy, acousticness, and tempo are within their expected ranges
if (all(simulated_data$valence >= 0.1 & simulated_data$valence <= 0.9)) {
  message("Test Passed: Valence is within the expected range.")
} else {
  stop("Test Failed: Valence is outside the expected range.")
}

if (all(simulated_data$temperature >= -10 & simulated_data$temperature <= 35)) {
  message("Test Passed: Temperature is within the expected range.")
} else {
  stop("Test Failed: Temperature is outside the expected range.")
}

if (all(simulated_data$danceability >= 0.5 & simulated_data$danceability <= 0.9)) {
  message("Test Passed: Danceability is within the expected range.")
} else {
  stop("Test Failed: Danceability is outside the expected range.")
}

if (all(simulated_data$energy >= 0.4 & simulated_data$energy <= 0.95)) {
  message("Test Passed: Energy is within the expected range.")
} else {
  stop("Test Failed: Energy is outside the expected range.")
}

if (all(simulated_data$acousticness >= 0 & simulated_data$acousticness <= 0.8)) {
  message("Test Passed: Acousticness is within the expected range.")
} else {
  stop("Test Failed: Acousticness is outside the expected range.")
}

if (all(simulated_data$tempo >= 60 & simulated_data$tempo <= 180)) {
  message("Test Passed: Tempo is within the expected range.")
} else {
  stop("Test Failed: Tempo is outside the expected range.")
}