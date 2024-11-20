#### Preamble ####
# Purpose: Tests the structure and validity of the analysis dataset.
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-clean_data.R must have been run.
# Any other information needed? None.

#### Workspace setup ####
library(tidyverse)

analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv", show_col_types = FALSE)


#### Test data ####
# Check if the dataset has the expected columns
expected_columns <- c("Artist", "Song", "Valence", "Max Temp", "Min Temp", 
                      "Mean Temp", "Danceability", "Energy", "Acousticness", "Tempo", "Date")

if (all(names(analysis_data) %in% expected_columns)) {
  message("Test Passed: The dataset has the correct columns.")
} else {
  stop("Test Failed: The dataset does not have the correct columns.")
}

# Check if all values in the 'Artist' column are non-missing and valid
if (all(!is.na(analysis_data$Artist))) {
  message("Test Passed: The 'Artist' column contains no missing values.")
} else {
  stop("Test Failed: The 'Artist' column contains missing values.")
}

# Check if all values in the 'Song' column are non-missing and valid
if (all(!is.na(analysis_data$Song))) {
  message("Test Passed: The 'Song' column contains no missing values.")
} else {
  stop("Test Failed: The 'Song' column contains missing values.")
}

# Check if Valence, Danceability, Energy, Acousticness, and Tempo are within their expected ranges
if (all(analysis_data$Valence >= 0 & analysis_data$Valence <= 1)) {
  message("Test Passed: Valence is within the expected range.")
} else {
  stop("Test Failed: Valence is outside the expected range.")
}

if (all(analysis_data$Danceability >= 0 & analysis_data$Danceability <= 1)) {
  message("Test Passed: Danceability is within the expected range.")
} else {
  stop("Test Failed: Danceability is outside the expected range.")
}

if (all(analysis_data$Energy >= 0 & analysis_data$Energy <= 1)) {
  message("Test Passed: Energy is within the expected range.")
} else {
  stop("Test Failed: Energy is outside the expected range.")
}

if (all(analysis_data$Acousticness >= 0 & analysis_data$Acousticness <= 1)) {
  message("Test Passed: Acousticness is within the expected range.")
} else {
  stop("Test Failed: Acousticness is outside the expected range.")
}

if (all(analysis_data$Tempo >= 40 & analysis_data$Tempo <= 205)) {
  message("Test Passed: Tempo is within the expected range.")
} else {
  stop("Test Failed: Tempo is outside the expected range.")
}


# Check if Max Temp, Min Temp, and Mean Temp are within realistic ranges
if (all(analysis_data$`Max Temp` >= -50 & analysis_data$`Max Temp` <= 50)) {
  message("Test Passed: Max Temp is within a realistic range.")
} else {
  stop("Test Failed: Max Temp is outside a realistic range.")
}

if (all(analysis_data$`Min Temp` >= -50 & analysis_data$`Min Temp` <= 50)) {
  message("Test Passed: Min Temp is within a realistic range.")
} else {
  stop("Test Failed: Min Temp is outside a realistic range.")
}

if (all(analysis_data$`Mean Temp` >= -50 & analysis_data$`Mean Temp` <= 50)) {
  message("Test Passed: Mean Temp is within a realistic range.")
} else {
  stop("Test Failed: Mean Temp is outside a realistic range.")
}

# Check for any missing values in the dataset
if (all(!is.na(analysis_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if Date values are valid and in the correct format
if (all(!is.na(as.Date(analysis_data$Date, format = "%Y-%m-%d")))) {
  message("Test Passed: All Date values are valid.")
} else {
  stop("Test Failed: There are invalid Date values.")
}