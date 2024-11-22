#### Preamble ####
# Purpose: Do some EDA to understand better our analysis dataset.
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
library(hexbin)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Summary statistics for numerical variables
numeric_summary <- analysis_data %>%
  reframe(
    Variable = c("Valence", "Mean Temp", "Danceability", "Energy", "Acousticness", "Tempo"),
    Mean = c(
      mean(Valence, na.rm = TRUE),
      mean(`Mean Temp`, na.rm = TRUE),
      mean(Danceability, na.rm = TRUE),
      mean(Energy, na.rm = TRUE),
      mean(Acousticness, na.rm = TRUE),
      mean(Tempo, na.rm = TRUE)
    ),
    SD = c(
      sd(Valence, na.rm = TRUE),
      sd(`Mean Temp`, na.rm = TRUE),
      sd(Danceability, na.rm = TRUE),
      sd(Energy, na.rm = TRUE),
      sd(Acousticness, na.rm = TRUE),
      sd(Tempo, na.rm = TRUE)
    ),
    Min = c(
      min(Valence, na.rm = TRUE),
      min(`Mean Temp`, na.rm = TRUE),
      min(Danceability, na.rm = TRUE),
      min(Energy, na.rm = TRUE),
      min(Acousticness, na.rm = TRUE),
      min(Tempo, na.rm = TRUE)
    ),
    Max = c(
      max(Valence, na.rm = TRUE),
      max(`Mean Temp`, na.rm = TRUE),
      max(Danceability, na.rm = TRUE),
      max(Energy, na.rm = TRUE),
      max(Acousticness, na.rm = TRUE),
      max(Tempo, na.rm = TRUE)
    )
  )

# Plot 1: Distribution of Valence
ggplot(analysis_data, aes(x = Valence)) +
  geom_histogram(binwidth = 0.05, fill = "blue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Valence", x = "Valence", y = "Count") +
  theme_minimal()

# Plot 2: Average temperature Over Time
ggplot(analysis_data, aes(x = Date, y = `Mean Temp`)) +
  geom_line(color = "red") +
  labs(title = "Average Temperature Over Time", x = "Date", y = "Temperature (°C)") +
  theme_minimal()

# Plot 3: Distribution of tempo
ggplot(analysis_data, aes(x = Tempo)) +
  geom_histogram(binwidth = 10, fill = "darkgreen", color = "black") +
  labs(title = "Distribution of Tempo", x = "Tempo (BPM)", y = "Frequency") +
  theme_minimal()

# Plot 4: Histogram for Danceability
ggplot(analysis_data, aes(x = Danceability)) +
  geom_histogram(binwidth = 0.05, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Danceability",
    x = "Danceability Score",
    y = "Frequency"
  ) +
  theme_minimal()

# Plot 5: Histogram for Energy
ggplot(analysis_data, aes(x = Energy)) +
  geom_histogram(binwidth = 0.05, fill = "darkgreen", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Energy",
    x = "Energy Level",
    y = "Frequency"
  ) +
  theme_minimal()

# Plot 6: Histogram for Acousticness
ggplot(analysis_data, aes(x = Acousticness)) +
  geom_histogram(binwidth = 0.05, fill = "purple", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Acousticness",
    x = "Acousticness Score",
    y = "Frequency"
  ) +
  theme_minimal()

# Plot 7: Visualize all three distributions in a single chart for comparison 
analysis_data %>%
  select(Danceability, Energy, Acousticness) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Value") %>%
  ggplot(aes(x = Value, fill = Variable)) +
  geom_histogram(binwidth = 0.05, alpha = 0.6, position = "identity", color = "black") +
  facet_wrap(~Variable, scales = "free") +
  labs(
    title = "Distribution of Danceability, Energy, and Acousticness",
    x = "Value",
    y = "Frequency"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


# Plot 8: Relationship between valence and danceability
ggplot(analysis_data, aes(x = Valence, y = Danceability)) +
  geom_hex(bins = 20) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  labs(
    title = "Density of Valence vs. Danceability",
    x = "Valence",
    y = "Danceability",
    fill = "Density"
  ) +
  theme_minimal()

# Plot 9: Relationship between valence vs temperature
analysis_data %>%
  mutate(Temp_Range = cut(`Mean Temp`, breaks = seq(0, 25, by = 5))) %>%
  ggplot(aes(x = Temp_Range, y = Valence, fill = after_stat(count))) + # Updated notation here
  stat_bin2d(binwidth = c(1, 0.1)) +
  scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Frequency") +
  labs(
    title = "Heatmap of Valence vs. Temperature",
    x = "Temperature Range (°C)",
    y = "Valence (Happiness)"
  ) +
  theme_minimal() +
  annotate(
    "text", x = 1, y = 0.05, label = "No data in this region", color = "darkred", size = 2.5
  )

# Plot 10: Average Danceability by Artist - Top 5
# Calculate mean danceability for each artist and filter the top 5
top_5_artists <- analysis_data %>%
  group_by(Artist) %>%
  summarise(Mean_Danceability = mean(Danceability, na.rm = TRUE)) %>%
  arrange(desc(Mean_Danceability)) %>%
  slice_max(order_by = Mean_Danceability, n = 5)

# Plot for the top 5 artists
ggplot(top_5_artists, aes(x = reorder(Artist, -Mean_Danceability), y = Mean_Danceability, fill = Artist)) +
  geom_bar(stat = "identity", color = "black", alpha = 0.8) +
  labs(
    title = "Top 5 Artists by Average Danceability",
    x = "Artist",
    y = "Average Danceability"
  ) +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()

# Plot 11: Average Temperature by Artist
# Calculate mean temperature for each artist
artist_temp <- analysis_data %>%
  group_by(Artist) %>%
  summarise(Mean_Temperature = mean(`Mean Temp`, na.rm = TRUE)) %>%
  arrange(Mean_Temperature)

# Select the top 5 artists with the highest and lowest temperatures
top_5_high_temp <- artist_temp %>%
  slice_max(order_by = Mean_Temperature, n = 5)

top_5_low_temp <- artist_temp %>%
  slice_min(order_by = Mean_Temperature, n = 5)

# Plot for artists with the highest temperatures
ggplot(top_5_high_temp, aes(x = reorder(Artist, Mean_Temperature), y = Mean_Temperature, fill = Artist)) +
  geom_bar(stat = "identity", color = "black", alpha = 0.8) +
  labs(
    title = "Top 5 Artists by Highest Average Temperature",
    x = "Artist",
    y = "Average Temperature (°C)"
  ) +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()

# Plot for artists with the lowest temperatures
ggplot(top_5_low_temp, aes(x = reorder(Artist, Mean_Temperature), y = Mean_Temperature, fill = Artist)) +
  geom_bar(stat = "identity", color = "black", alpha = 0.8) +
  labs(
    title = "Top 5 Artists by Lowest Average Temperature",
    x = "Artist",
    y = "Average Temperature (°C)"
  ) +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()

