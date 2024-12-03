#### Preamble ####
# Purpose: Models the exploratory data analysis of the COVID-19 dataset
# Author: Bruce Zhang
# Date: 3 December 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - 03-clean_data.R must have been run
# Any other information needed? 

# Load necessary libraries
library(tidyverse)
library(dplyr)
library(ggplot2)
library(corrplot) 
library(DataExplorer) 

# Set random seed for reproducibility
set.seed(21)

# Step 1: Load the data (make sure to change the file path to your actual dataset)
analysis_data <- read_parquet(here("data", "02-analysis_data", "analysis_data.parquet"))

# Step 2: Data Overview
# View the structure of the data
str(analysis_data)

# Check for missing values
summary(analysis_data)

# Get the summary statistics of numerical columns
summary_stats <- analysis_data %>%
  select_if(is.numeric) %>%
  summary()

# Step 3: Exploratory Visualizations
# Histogram for distribution of numerical variables (e.g., Cases, Deaths, Tests)
ggplot(analysis_data, aes(x = Cases)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Cases", x = "Cases", y = "Frequency")

ggplot(analysis_data, aes(x = Deaths)) +
  geom_histogram(bins = 30, fill = "salmon", color = "black", alpha = 0.7) +
  labs(title = "Distribution of Deaths", x = "Deaths", y = "Frequency")

# Correlation plot for numerical variables
numeric_data <- analysis_data %>% select_if(is.numeric)
corr_matrix <- cor(numeric_data, use = "complete.obs")
corrplot(corr_matrix, method = "circle", type = "upper", tl.cex = 0.7, tl.col = "black")

# Boxplots by categorical variables (e.g., by Region and Sex)
ggplot(analysis_data, aes(x = Region, y = Cases, fill = Region)) +
  geom_boxplot() +
  labs(title = "Cases by Region", x = "Region", y = "Cases")

ggplot(analysis_data, aes(x = Sex, y = Deaths, fill = Sex)) +
  geom_boxplot() +
  labs(title = "Deaths by Sex", x = "Sex", y = "Deaths")

# Step 4: Automate some basic EDA
# Using DataExplorer to generate an overview of the dataset
create_report(analysis_data, output_dir = "eda_report")

# Step 5: Save the analysis results as an RDS file
saveRDS(list(summary_stats = summary_stats, correlation_matrix = corr_matrix), "eda_results.rds")
