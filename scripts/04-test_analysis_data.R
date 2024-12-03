#### Preamble ####
# Purpose: Tests the analysis data for any potential problems that may compromise the analysis. 
# Author: Bruce Zhang
# Date: 23 September 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
 # - 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `COVID_demographics` rproj


#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)
library(testthat)  # For unit testing

# Load the data
analysis_data_path <- "data/02-analysis_data/analysis_data.parquet"
analysis_data <- read_parquet(analysis_data_path)

# Test 1: Check the basic structure of the dataset
test_that("Dataset has the expected structure", {
  expect_s3_class(analysis_data, "data.frame")  # Dataset should be a data frame
  expect_true(all(c("Country", "Region", "Code", "Date", "Sex", "Age", "AgeInt", "Cases", "Deaths", "Tests") %in% colnames(analysis_data)))
})

# Test 2: Check for missing values in key columns
test_that("There are no missing values in key columns", {
  missing_summary <- analysis_data %>%
    summarise(across(everything(), ~ sum(is.na(.)))) %>%
    pivot_longer(cols = everything(), names_to = "Variable", values_to = "Missing_Count")
  
  expect_equal(missing_summary$Missing_Count, rep(0, length(missing_summary$Missing_Count)))  # Ensure no missing values in any column
})

# Test 3: Check for duplicates
test_that("There are no duplicate rows", {
  duplicates <- sum(duplicated(analysis_data))
  expect_equal(duplicates, 0)  # Ensure there are no duplicate rows
})

# Test 4: Check summary statistics for numeric columns
test_that("Numeric columns have valid summary statistics", {
  numeric_summary <- analysis_data %>%
    summarise(
      Total_Cases = sum(Cases, na.rm = TRUE),
      Total_Deaths = sum(Deaths, na.rm = TRUE),
      Total_Tests = sum(Tests, na.rm = TRUE)
    )
  
  expect_true(numeric_summary$Total_Cases >= 0)
  expect_true(numeric_summary$Total_Deaths >= 0)
  expect_true(numeric_summary$Total_Tests >= 0)
})

# Test 5: Validate unique combinations of key columns
test_that("Unique combinations of key columns are correct", {
  unique_combinations <- analysis_data %>%
    distinct(Country, Region, Code, Date, Sex, Age, AgeInt) %>%
    nrow()
  
  expect_gt(unique_combinations, 0)  # Ensure there are some unique combinations
})

# Test 6: Validate categorical columns
test_that("Categorical columns have expected unique values", {
  valid_regions <- c("Urban", "Rural", "All")
  valid_sexes <- c("m", "f", "b")
  
  region_values <- unique(analysis_data$Region)
  sex_values <- unique(analysis_data$Sex)
  
  invalid_regions <- setdiff(region_values, valid_regions)
  invalid_sexes <- setdiff(sex_values, valid_sexes)
  
  expect_length(invalid_regions, 0)  # Ensure there are no invalid regions
  expect_length(invalid_sexes, 0)    # Ensure there are no invalid sexes
})

# Test 7: Check for logical errors (negative values or deaths exceeding cases)
test_that("There are no negative values or logical errors in the data", {
  negative_values <- analysis_data %>%
    filter(Cases < 0 | Deaths < 0 | Tests < 0)
  
  expect_equal(nrow(negative_values), 0)  # Ensure no negative values
  
  invalid_death_cases <- analysis_data %>%
    filter(Deaths > Cases)
  
  expect_equal(nrow(invalid_death_cases), 0)  # Ensure deaths do not exceed cases
})

# Test 8: Visualizing distributions (optional, visual check)
test_that("Visualizations are generated correctly", {
  expect_silent(ggplot(analysis_data, aes(x = Region, y = Cases, fill = Region)) + 
                  geom_boxplot(alpha = 0.6) + 
                  labs(title = "Distribution of Cases by Region", x = "Region", y = "Number of Cases") + 
                  theme_minimal())
  
  expect_silent(ggplot(analysis_data, aes(x = Age, weight = Deaths)) + 
                  geom_histogram(binwidth = 5, fill = "blue", color = "black", alpha = 0.7) + 
                  labs(title = "Distribution of Deaths by Age", x = "Age", y = "Number of Deaths") + 
                  theme_minimal())
})

