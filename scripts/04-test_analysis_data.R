#### Preamble ####
# Purpose: Tests the structure and validity of the analysis dataset.
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#    - 02-clean_data.R must have been run.
#    - Install `testthat`.
# Any other information needed? None.

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(testthat)

analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")


#### Test data ####
analysis_data_tes <- analysis_data %>%
  select(-`Scaled Mean Temp`, -`Scaled Tempo`)


test_that("Dataset has the correct columns", {
  expected_columns <- c("Artist", "Song", "Valence", "Max Temp", "Min Temp", 
                        "Mean Temp", "Danceability", "Acousticness", "Tempo", 
                        "Date")
  expect_setequal(names(analysis_data_tes), expected_columns)
})

test_that("No missing values in critical columns", {
  expect_true(all(!is.na(analysis_data_tes$Artist)), info = "The 'Artist' column contains missing values.")
  expect_true(all(!is.na(analysis_data_tes$Song)), info = "The 'Song' column contains missing values.")
})

test_that("Valence, Danceability, Acousticness, are within valid ranges", {
  expect_true(all(analysis_data_tes$Valence >= 0 & analysis_data_tes$Valence <= 1), 
              info = "Valence values are outside the range [0, 1].")
  expect_true(all(analysis_data_tes$Danceability >= 0 & analysis_data_tes$Danceability <= 1), 
              info = "Danceability values are outside the range [0, 1].")
  expect_true(all(analysis_data_tes$Acousticness >= 0 & analysis_data_tes$Acousticness <= 1), 
              info = "Acousticness values are outside the range [0, 1].")
})

test_that("Tempo is within the expected range", {
  expect_true(all(analysis_data_tes$Tempo >= 40 & analysis_data_tes$Tempo <= 205), 
              info = "Tempo values are outside the range [40, 205].")
})

test_that("Temperatures are within realistic ranges", {
  expect_true(all(analysis_data_tes$`Max Temp` >= -50 & analysis_data_tes$`Max Temp` <= 50), 
              info = "Max Temp values are outside the range [-50, 50].")
  expect_true(all(analysis_data_tes$`Min Temp` >= -50 & analysis_data_tes$`Min Temp` <= 50), 
              info = "Min Temp values are outside the range [-50, 50].")
  expect_true(all(analysis_data_tes$`Mean Temp` >= -50 & analysis_data_tes$`Mean Temp` <= 50), 
              info = "Mean Temp values are outside the range [-50, 50].")
})

test_that("Dataset has no missing values", {
  expect_true(all(!is.na(analysis_data_tes)), 
              info = "The dataset contains missing values.")
})

test_that("Date values are valid", {
  expect_true(all(!is.na(as.Date(analysis_data_tes$Date, format = "%Y-%m-%d"))), 
              info = "There are invalid Date values in the dataset.")
})