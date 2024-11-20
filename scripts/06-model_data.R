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
library(pROC)  # For AUC calculation

#### Read data ####
#### Read simulated dataset ####
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

# Scale numeric predictors for better interpretability
analysis_data <- analysis_data %>%
  mutate(
    temperature_scaled = scale(temperature),
    danceability_scaled = scale(danceability),
    energy_scaled = scale(energy),
    acousticness_scaled = scale(acousticness),
    tempo_scaled = scale(tempo),
    artist = as.factor(artist)  # Factorize categorical variable
  )

#### Split into training and testing datasets ####
set.seed(123)
train_indices <- sample(seq_len(nrow(analysis_data)), size = 0.7 * nrow(analysis_data))
training_data <- analysis_data[train_indices, ]
testing_data <- analysis_data[-train_indices, ]

#### Multiple Linear Regression Model ####
# Fit the linear regression model
lm_model <- lm(
  valence ~ temperature_scaled + artist + danceability_scaled + 
    energy_scaled + acousticness_scaled + tempo_scaled,
  data = training_data
)

# Summarize the model
summary(lm_model)

# Make predictions on the test set
testing_data <- testing_data %>%
  mutate(predicted_valence_lm = predict(lm_model, newdata = testing_data))

# Evaluate the model
lm_rmse <- RMSE(testing_data$valence, testing_data$predicted_valence_lm)
lm_r2 <- R2_Score(testing_data$valence, testing_data$predicted_valence_lm)

# Calculate AUC for Linear Model
lm_auc <- roc(testing_data$valence, testing_data$predicted_valence_lm)$auc

cat("Linear Model - RMSE:", lm_rmse, "R-squared:", lm_r2, "AUC:", lm_auc, "\n")

#### Bayesian Linear Regression Model ####
library(rstanarm)

# Fit the Bayesian linear regression model
set.seed(123)
bayesian_model <- stan_glm(
  valence ~ temperature_scaled + (1|artist) + danceability_scaled + 
    energy_scaled + acousticness_scaled + tempo_scaled,
  data = training_data,
  family = gaussian(),
  prior = normal(0, 1, autoscale = TRUE),
  prior_intercept = normal(0, 1, autoscale = TRUE),
  chains = 4,
  iter = 2000,
  seed = 123
)

# Summarize the Bayesian model
summary(bayesian_model)

# Make predictions on the test set
testing_data <- testing_data %>%
  mutate(predicted_valence_bayesian = posterior_predict(bayesian_model, newdata = testing_data) %>% colMeans())

# Evaluate the Bayesian model
bayesian_rmse <- RMSE(testing_data$valence, testing_data$predicted_valence_bayesian)
bayesian_r2 <- R2_Score(testing_data$valence, testing_data$predicted_valence_bayesian)

# Calculate AUC for Bayesian Model
bayesian_auc <- roc(testing_data$valence, testing_data$predicted_valence_bayesian)$auc

cat("Bayesian Model - RMSE:", bayesian_rmse, "R-squared:", bayesian_r2, "AUC:", bayesian_auc, "\n")

#### Compare Results ####
comparison <- tibble(
  Model = c("Linear Regression", "Bayesian Regression"),
  RMSE = c(lm_rmse, bayesian_rmse),
  R_Squared = c(lm_r2, bayesian_r2),
  AUC = c(lm_auc, bayesian_auc)
)

print(comparison)

#### Save Models ####
saveRDS(lm_model, "models/lm_model.rds")
saveRDS(bayesian_model, "models/bayesian_model.rds")


