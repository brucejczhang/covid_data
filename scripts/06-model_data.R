#### Preamble ####
# Purpose: Models the predicted probability of high risk based on the predictor variables of the dataset
# Author: Bruce Zhang
# Date: 25 November 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `COVID_demographics` rproj

# Install and load necessary pacakges/libraries
install.packages("caret")
install.packages("pROC")
library(ggplot2)
library(dplyr)
library(caret)
library(pROC)

# Building a logistic regression model for predicted high risk and age
# Step 1: Build the logistic regression model
logistic_model <- glm(
  High_Risk ~ Age + Region + Sex,  # Replace with relevant predictors
  data = analysis_data,
  family = binomial()
)

# Step 2: Model Summary and Diagnostics
cat("Model Summary:\n")
print(summary(logistic_model))
cat("\nAIC:", AIC(logistic_model), "\nBIC:", BIC(logistic_model), "\n")

# Step 3: Predicted Probabilities and Classification
analysis_data <- analysis_data %>%
  mutate(
    Predicted_Probability = predict(logistic_model, type = "response"),
    Predicted_Class = ifelse(Predicted_Probability > 0.5, 1, 0)  # Classification threshold
  )

# Step 4: Confusion Matrix
cat("\nConfusion Matrix:\n")
conf_matrix <- confusionMatrix(
  factor(analysis_data$Predicted_Class),
  factor(analysis_data$High_Risk)
)
print(conf_matrix)

# Step 5: ROC Curve and AUC
roc_curve <- roc(analysis_data$High_Risk, analysis_data$Predicted_Probability)
plot(roc_curve, main = "ROC Curve")
auc_value <- auc(roc_curve)
cat("\nAUC:", auc_value, "\n")

# Step 6: Odds Ratios and Confidence Intervals
cat("\nOdds Ratios:\n")
print(exp(coef(logistic_model)))  # Odds Ratios
cat("\nConfidence Intervals for Odds Ratios:\n")
print(exp(confint(logistic_model)))

# Step 7: Visualize Predicted Probabilities by Age
filtered_data <- analysis_data %>%
  mutate(
    Age_Interval = cut(Age, breaks = seq(0, 100, by = 10), right = FALSE, include.lowest = TRUE), # Create age intervals
    Death_Rate = Deaths / (Cases + 1e-6), # Calculate death rate (avoid division by zero)
    High_Risk = ifelse(Death_Rate > median(Death_Rate, na.rm = TRUE), 1, 0) # Classify high-risk regions
  ) %>%
  filter(!is.na(Age_Interval)) # Remove any rows with missing age intervals

logistic_model <- glm(
  High_Risk ~ Tests + Age_Interval,
  family = binomial(),
  data = filtered_data
)

summary(logistic_model)

filtered_data <- filtered_data %>%
  mutate(Predicted_Probability = predict(logistic_model, type = "response"))

ggplot(filtered_data, aes(x = Age_Interval, y = Predicted_Probability, fill = Age_Interval)) +
  geom_boxplot(alpha = 0.6) +
  labs(
    title = "",
    x = "Age Interval",
    y = "Predicted Probability of High Risk"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x-axis labels for readability

# Step 8: Save the Model for Future Use
saveRDS(logistic_model, file = "models/logistic_model.rds")


# Building a logistic regression model for predicted high risk and sex
# Step 1: Filter Data and Define High Risk
filtered_data <- analysis_data %>%
  filter(Sex %in% c("f", "m")) %>% # Include only 'f' and 'm'
  mutate(
    Death_Rate = Deaths / (Cases + 1e-6), # Calculate death rate (avoid division by zero)
    High_Risk = ifelse(Death_Rate > median(Death_Rate, na.rm = TRUE), 1, 0) # Classify high-risk individuals
  )

# Step 2: Fit Logistic Regression Model
logistic_model <- glm(
  High_Risk ~ Tests + Sex + Age,  # Predictors: Tests, Sex, Age
  family = binomial(),
  data = filtered_data
)

# Output Model Summary
cat("Logistic Regression Model Summary:\n")
print(summary(logistic_model))

# Step 3: Add Predictions to the Dataset
filtered_data <- filtered_data %>%
  mutate(
    Predicted_Probability = predict(logistic_model, type = "response"),
    Predicted_Class = ifelse(Predicted_Probability > 0.5, 1, 0) # Classify based on 0.5 threshold
  )

# Step 4: Evaluate the Model
# Confusion Matrix
cat("\nConfusion Matrix:\n")
conf_matrix <- confusionMatrix(
  factor(filtered_data$Predicted_Class),
  factor(filtered_data$High_Risk)
)
print(conf_matrix)

# ROC Curve and AUC
roc_curve <- roc(filtered_data$High_Risk, filtered_data$Predicted_Probability)
auc_value <- auc(roc_curve)
cat("\nArea Under the Curve (AUC):", auc_value, "\n")

# Plot ROC Curve
plot(roc_curve, main = "ROC Curve for High Risk by Sex")

# Step 5: Visualize Predicted Probabilities by Sex
ggplot(filtered_data, aes(x = Sex, y = Predicted_Probability, fill = Sex)) +
  geom_boxplot(alpha = 0.6) +
  labs(
    title = "Predicted Probability of High Risk by Sex",
    x = "Sex",
    y = "Predicted Probability of High Risk"
  ) +
  theme_minimal()

# Step 6: Save the Model for Reproducibility
saveRDS(logistic_model, file = "models/logistic_model_sex_high_risk.rds")


# Building a logistic regression model for predicted high risk and region
# Step 1: Filter Data and Define High Risk
filtered_data <- analysis_data %>%
  filter(Region %in% c("Urban", "Rural")) %>% # Include only 'Urban' and 'Rural'
  mutate(
    Death_Rate = Deaths / (Cases + 1e-6), # Calculate death rate (avoid division by zero)
    High_Risk = ifelse(Death_Rate > median(Death_Rate, na.rm = TRUE), 1, 0) # Classify high-risk regions
  )

# Step 2: Fit Logistic Regression Model
logistic_model <- glm(
  High_Risk ~ Tests + Region + Age,  # Predictors: Tests, Region, Age
  family = binomial(),
  data = filtered_data
)

# Output Model Summary
cat("Logistic Regression Model Summary:\n")
print(summary(logistic_model))

# Step 3: Add Predictions to the Dataset
filtered_data <- filtered_data %>%
  mutate(
    Predicted_Probability = predict(logistic_model, type = "response"),
    Predicted_Class = ifelse(Predicted_Probability > 0.5, 1, 0) # Classify based on 0.5 threshold
  )

# Step 4: Evaluate the Model
# Confusion Matrix
cat("\nConfusion Matrix:\n")
conf_matrix <- confusionMatrix(
  factor(filtered_data$Predicted_Class),
  factor(filtered_data$High_Risk)
)
print(conf_matrix)

# ROC Curve and AUC
roc_curve <- roc(filtered_data$High_Risk, filtered_data$Predicted_Probability)
auc_value <- auc(roc_curve)
cat("\nArea Under the Curve (AUC):", auc_value, "\n")

# Plot ROC Curve
plot(roc_curve, main = "ROC Curve for High Risk by Region")

# Step 5: Visualize Predicted Probabilities by Region
ggplot(filtered_data, aes(x = Region, y = Predicted_Probability, fill = Region)) +
  geom_boxplot(alpha = 0.6) +
  labs(
    title = "Predicted Probability of High Risk by Region",
    x = "Region",
    y = "Predicted Probability of High Risk"
  ) +
  theme_minimal()

# Step 6: Save the Model for Reproducibility
saveRDS(logistic_model, file = "models/logistic_model_region_high_risk.rds")
