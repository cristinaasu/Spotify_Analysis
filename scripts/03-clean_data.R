#### Preamble ####
# Purpose: [...UPDATE THIS...]
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_csv("inputs/data/plane_data.csv")


#things i have to do: merge the weather and top50 dataset, rename variables, 
#drop columns i dont need, check for missing values. variables potentially using 
#are valence, temperature, artist, danceability, energy, acousticness, tempo



#### Save data ####
write_csv(cleaned_data, "outputs/data/analysis_data.csv")
