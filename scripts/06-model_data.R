#### Preamble ####
# Purpose: Fitting MLR models with varied predictors, performs testing and validation, 
#          and compares their performance.
# Author: Cristina Su Lam
# Date: 19 November 2024
# Contact: cristina.sulam@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
#   - Install required libraries: `tidyverse`, `MLmetrics`, `arrow`, `stats`.
# Any other information needed? None.

#### Workspace setup ####
library(tidyverse)
library(MLmetrics)  
library(arrow)
library(stats)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Scale numeric predictors for better interpretability
analysis_data <- analysis_data %>%
  mutate(
    Artist = as.factor(Artist)
  )

### Model Validation/Checking ###
# Split into training and testing datasets
set.seed(123)
train_indices <- sample(seq_len(nrow(analysis_data)), size = 0.7 * nrow(analysis_data))
training_data <- analysis_data[train_indices, ]
testing_data <- analysis_data[-train_indices, ]

# Fit the MLR - Version 1
mlm_model <- lm(
  Valence ~ `Scaled Mean Temp` + Artist + Danceability + Acousticness + `Scaled Tempo` + Date,
  data = training_data
)

# Filter test data to only include artists found in the training set to ensure compatibility
testing_data <- testing_data |> 
  filter(Artist %in% unique(training_data$Artist))

# Make predictions on the test set
mlm_testing_data <- testing_data %>%
  mutate(predicted_valence_lm = predict(mlm_model, newdata = testing_data))

# Evaluate the model
mlm_rmse <- RMSE(testing_data$Valence, mlm_testing_data$predicted_valence_lm)
mlm_r2 <- R2_Score(testing_data$Valence, mlm_testing_data$predicted_valence_lm)

cat("RMSE:", mlm_rmse, "R-squared:", mlm_r2)

# Fit the MLR - Version 2
mlm_model2 <- lm(
  Valence ~ `Scaled Mean Temp` + Artist + Danceability + 
    Acousticness + `Scaled Tempo`,
  data = training_data
)

mlm_testing_data2 <- testing_data %>%
  mutate(predicted_valence_lm = predict(mlm_model2, newdata = testing_data))

# Evaluate the model
mlm_rmse2 <- RMSE(testing_data$Valence, mlm_testing_data2$predicted_valence_lm)
mlm_2r2 <- R2_Score(testing_data$Valence, mlm_testing_data2$predicted_valence_lm)

cat("RMSE:", mlm_rmse2, "R-squared:", mlm_2r2)

# Fit the MLR - Version 3
mlm_model3 <- lm(
  Valence ~ `Scaled Mean Temp` + Danceability + 
    Acousticness + `Scaled Tempo`,
  data = training_data
)

mlm_testing_data3 <- testing_data %>%
  mutate(predicted_valence_lm = predict(mlm_model3, newdata = testing_data))

# Evaluate the model
mlm_rmse3 <- RMSE(testing_data$Valence, mlm_testing_data3$predicted_valence_lm)
mlm_3r2 <- R2_Score(testing_data$Valence, mlm_testing_data3$predicted_valence_lm)

cat("RMSE:", mlm_rmse3, "R-squared:", mlm_3r2)

#### Compare Results ####
comparison <- tibble(
  Model = c("MLR 1", "MLR 2", "MLR 3"),
  RMSE = c(mlm_rmse, mlm_rmse2, mlm_rmse3),
  R_Squared = c(mlm_r2, mlm_2r2, mlm_3r2)
)

#### MLR - Version 1 - Entire Dataset ####
# Based on the comparison results, the first model was selected for its performance, 
# and predictions will now be made using the entire dataset.
# Fit the MLR
mlm_model_analysis <- lm(
  Valence ~ `Scaled Mean Temp` + Artist + Danceability + Acousticness + `Scaled Tempo`,
  data = analysis_data
)

modelsummary(mlm_model_analysis)
# Make predictions 
mlm_data_analysis <- analysis_data %>%
  mutate(predicted_valence_lm = predict(mlm_model_analysis, newdata = analysis_data))

#### Save Models ####
saveRDS(mlm_model_analysis, "models/mlm_model.rds")



