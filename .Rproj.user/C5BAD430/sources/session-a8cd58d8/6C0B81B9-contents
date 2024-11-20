#### Preamble ####
# Purpose: Simulates a dataset combining the Top 50 songs in Canada 
           #with corresponding daily average temperatures for major cities. 
# Author: Cristina Su Lam
# Date: 18 November 2024
# Contact: cristina.sulam@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed.
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(123)

#### Simulate data ####

# Predefined mapping of songs to artists
song_artist_mapping <- tibble(
  track_name = c(
    "This is me trying", "Fearless", "About you", "Robbers", "Free Now",
    "Close to you", "Sparks", "Paradise", "Little Things", "Right Now"
  ),
  artist = c(
    "Taylor Swift", "Taylor Swift", "The 1975", "The 1975", "Gracie Abrams",
    "Gracie Abrams", "Coldplay", "Coldplay", "One Direction", "One Direction"
  )
)

# Simulate daily dates
dates <- seq(
  from = as.Date("2024-06-01"),
  to = as.Date("2024-11-16"),
  by = "day"
)

# Generate summer temperatures (June to August)
summer_dates <- dates[dates <= as.Date("2024-08-31")]
summer_temps <- runif(length(summer_dates), min = 18, max = 30)

# Generate fall temperatures (September to November)
fall_dates <- dates[dates > as.Date("2024-08-31")]
fall_temps <- seq(17, -5, length.out = length(fall_dates))

# Combine summer and fall temperatures
all_temps <- c(summer_temps, fall_temps)

# Create daily temperature tibble
daily_temperature <- tibble(
  date = dates,
  temperature = all_temps
)

# Simulate the dataset
simulated_data <- tibble(
  date = rep(dates, each = nrow(song_artist_mapping)),  # Repeat for each date
  track_name = rep(song_artist_mapping$track_name, times = length(dates)),  # Match songs
  artist = rep(song_artist_mapping$artist, times = length(dates)),  # Match artists
  valence = runif(length(dates) * nrow(song_artist_mapping), min = 0.1, max = 0.9),  # Valence (happiness)
  danceability = runif(length(dates) * nrow(song_artist_mapping), min = 0.5, max = 0.9),  # Danceability score
  energy = runif(length(dates) * nrow(song_artist_mapping), min = 0.4, max = 0.95),  # Energy level
  acousticness = runif(length(dates) * nrow(song_artist_mapping), min = 0, max = 0.8),  # Acousticness level
  tempo = runif(length(dates) * nrow(song_artist_mapping), min = 60, max = 180)  # Tempo in BPM
) %>%
  left_join(daily_temperature, by = "date") 

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
