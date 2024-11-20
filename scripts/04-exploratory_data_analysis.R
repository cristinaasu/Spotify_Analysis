#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

# Summary statistics for numerical variables
numeric_summary <- analysis_data %>%
  summarise(
    mean_valence = mean(valence, na.rm = TRUE),
    sd_valence = sd(valence, na.rm = TRUE),
    min_valence = min(valence, na.rm = TRUE),
    max_valence = max(valence, na.rm = TRUE),
    mean_temperature = mean(temperature, na.rm = TRUE),
    sd_temperature = sd(temperature, na.rm = TRUE),
    min_temperature = min(temperature, na.rm = TRUE),
    max_temperature = max(temperature, na.rm = TRUE),
    mean_danceability = mean(danceability, na.rm = TRUE),
    sd_danceability = sd(danceability, na.rm = TRUE),
    min_danceability = min(danceability, na.rm = TRUE),
    max_danceability = max(danceability, na.rm = TRUE),
    mean_energy = mean(energy, na.rm = TRUE),
    sd_energy = sd(energy, na.rm = TRUE),
    min_energy = min(energy, na.rm = TRUE),
    max_energy = max(energy, na.rm = TRUE),
    mean_acousticness = mean(acousticness, na.rm = TRUE),
    sd_acousticness = sd(acousticness, na.rm = TRUE),
    min_acousticness = min(acousticness, na.rm = TRUE),
    max_acousticness = max(acousticness, na.rm = TRUE),
    mean_tempo = mean(tempo, na.rm = TRUE),
    sd_tempo = sd(tempo, na.rm = TRUE),
    min_tempo = min(tempo, na.rm = TRUE),
    max_tempo = max(tempo, na.rm = TRUE)
  )

# Plot 1: Distribution of Valence
ggplot(analysis_data, aes(x = valence)) +
  geom_histogram(binwidth = 0.05, fill = "blue", alpha = 0.7) +
  labs(title = "Distribution of Valence", x = "Valence", y = "Count") +
  theme_minimal()

# Plot 2: Average temperature Over Time
ggplot(analysis_data, aes(x = date, y = temperature)) +
  geom_line(color = "red") +
  labs(title = "Average Temperature Over Time", x = "Date", y = "Temperature (°C)") +
  theme_minimal()

# Plot 3: Distribution of tempo
ggplot(simulated_data, aes(x = tempo)) +
  geom_histogram(binwidth = 10, fill = "darkgreen", color = "black") +
  labs(title = "Distribution of Tempo", x = "Tempo (BPM)", y = "Frequency") +
  theme_minimal()

# Plot 4: Histogram for Danceability
ggplot(simulated_data, aes(x = danceability)) +
  geom_histogram(binwidth = 0.05, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Danceability",
    x = "Danceability Score",
    y = "Frequency"
  ) +
  theme_minimal()

# Plot 5: Histogram for Energy
ggplot(simulated_data, aes(x = energy)) +
  geom_histogram(binwidth = 0.05, fill = "darkgreen", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Energy",
    x = "Energy Level",
    y = "Frequency"
  ) +
  theme_minimal()

# Plot 6: Histogram for Acousticness
ggplot(simulated_data, aes(x = acousticness)) +
  geom_histogram(binwidth = 0.05, fill = "purple", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Acousticness",
    x = "Acousticness Score",
    y = "Frequency"
  ) +
  theme_minimal()

# Plot 7: Visualize all three distributions in a single chart for comparison (this is a good idea)
simulated_data %>%
  select(danceability, energy, acousticness) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Value") %>%
  ggplot(aes(x = Value, fill = Variable)) +
  geom_histogram(binwidth = 0.05, alpha = 0.6, position = "identity", color = "black") +
  facet_wrap(~Variable, scales = "free") +
  labs(
    title = "Distribution of Danceability, Energy, and Acousticness",
    x = "Value",
    y = "Frequency"
  ) +
  theme_minimal()


# Plot 8: Relationship between valence and danceability
ggplot(simulated_data, aes(x = valence, y = danceability)) +
  geom_point(color = "purple", alpha = 0.6) +
  labs(title = "Valence vs. Danceability", x = "Valence", y = "Danceability") +
  theme_minimal()

# Plot 9: Scatterplot of valence vs temperature
ggplot(simulated_data, aes(x = temperature, y = valence)) +
  geom_point(alpha = 0.6, color = "blue") +
  geom_smooth(method = "lm", color = "red", linetype = "dashed", se = TRUE) +
  labs(
    title = "Relationship between Valence and Temperature",
    x = "Temperature (°C)",
    y = "Valence (Happiness)"
  ) +
  theme_minimal()

# Plot 10: Average Danceability by Artist
ggplot(simulated_data, aes(x = artist, y = danceability, fill = artist)) +
  geom_bar(stat = "summary", fun = "mean", color = "black", alpha = 0.8) +
  labs(
    title = "Average Danceability by Artist",
    x = "Artist",
    y = "Average Danceability"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Plot 11: Average Temperature by Artist
ggplot(simulated_data, aes(x = artist, y = temperature, fill = artist)) +
  geom_bar(stat = "summary", fun = "mean", color = "black", alpha = 0.8) +
  labs(
    title = "Average Temperature by Artist",
    x = "Artist",
    y = "Average Temperature (°C)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


