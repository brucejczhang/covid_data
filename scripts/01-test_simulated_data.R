#### Preamble ####
# Purpose: Tests the structure, validity, and any inconsistencies or missing data of the simulated COVID demographics dataset. 
# Author: Bruce Zhang
# Date: 21 November 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - The `dplyr` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `COVID_demographics` rproj


#### Workspace setup ####
library(tidyverse)
library(dplyr)

analysis_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Load necessary library
library(dplyr)

# Test 1: Verify structure of the dataset
str(simulated_data)

# Test 2: Check for missing values in key columns
missing_summary <- simulated_data %>%
  summarise(
    Missing_Country = sum(is.na(Country)),
    Missing_Region = sum(is.na(Region)),
    Missing_Code = sum(is.na(Code)),
    Missing_Date = sum(is.na(Date)),
    Missing_Sex = sum(is.na(Sex)),
    Missing_Age = sum(is.na(Age)),
    Missing_Cases = sum(is.na(Cases)),
    Missing_Deaths = sum(is.na(Deaths)),
    Missing_Tests = sum(is.na(Tests))
  )
print("Missing values summary:")
print(missing_summary)

# Test 3: Summary statistics for numeric columns
numeric_summary <- simulated_data %>%
  summarise(
    Min_Cases = min(Cases, na.rm = TRUE),
    Max_Cases = max(Cases, na.rm = TRUE),
    Mean_Cases = mean(Cases, na.rm = TRUE),
    Min_Deaths = min(Deaths, na.rm = TRUE),
    Max_Deaths = max(Deaths, na.rm = TRUE),
    Mean_Deaths = mean(Deaths, na.rm = TRUE),
    Min_Tests = min(Tests, na.rm = TRUE),
    Max_Tests = max(Tests, na.rm = TRUE),
    Mean_Tests = mean(Tests, na.rm = TRUE)
  )
print("Summary statistics for numeric columns:")
print(numeric_summary)

# Test 4: Verify unique combinations of key columns
unique_combinations <- simulated_data %>%
  distinct(Country, Region, Code, Date, Sex, Age, AgeInt) %>%
  nrow()
print(paste("Number of unique rows based on key columns:", unique_combinations))

# Test 5: Check for inconsistencies in categorical columns
category_checks <- simulated_data %>%
  summarise(
    Unique_Countries = n_distinct(Country),
    Unique_Regions = n_distinct(Region),
    Unique_Codes = n_distinct(Code),
    Unique_Sexes = n_distinct(Sex)
  )
print("Category checks summary:")
print(category_checks)

# Test 6: Plot distributions for numerical data (optional, visual check)
hist(simulated_data$Cases, main = "Distribution of Cases", xlab = "Cases", col = "lightblue", breaks = 20)
hist(simulated_data$Deaths, main = "Distribution of Deaths", xlab = "Deaths", col = "lightgreen", breaks = 20)
hist(simulated_data$Tests, main = "Distribution of Tests", xlab = "Tests", col = "lightpink", breaks = 20)
