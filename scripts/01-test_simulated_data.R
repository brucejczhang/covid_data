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
library(arrow)
library(testthat)

# Read the data
analysis_data <- read_parquet("data/00-simulated_data/simulated_data.parquet")

# Test 1: Verify structure of the dataset
test_that("Dataset has the expected structure", {
  expect_s3_class(analysis_data, "data.frame")  # Check that the dataset is a data frame
  expect_true(all(c("Country", "Region", "Code", "Date", "Sex", "Age", "AgeInt", "Cases", "Deaths", "Tests") %in% colnames(analysis_data)))
})

# Test 2: Check for missing values in key columns
test_that("There are no missing values in key columns", {
  missing_summary <- analysis_data %>%
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
  expect_equal(missing_summary$Missing_Country, 0)
  expect_equal(missing_summary$Missing_Region, 0)
  expect_equal(missing_summary$Missing_Code, 0)
  expect_equal(missing_summary$Missing_Date, 0)
  expect_equal(missing_summary$Missing_Sex, 0)
  expect_equal(missing_summary$Missing_Age, 0)
  expect_equal(missing_summary$Missing_Cases, 0)
  expect_equal(missing_summary$Missing_Deaths, 0)
  expect_equal(missing_summary$Missing_Tests, 0)
})

# Test 3: Summary statistics for numeric columns
test_that("Numeric columns have valid summary statistics", {
  numeric_summary <- analysis_data %>%
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
  expect_true(numeric_summary$Min_Cases >= 0)  # Min cases should be non-negative
  expect_true(numeric_summary$Max_Cases >= numeric_summary$Min_Cases)  # Max cases should be >= Min cases
})

# Test 4: Verify unique combinations of key columns
test_that("Unique combinations of key columns are correct", {
  unique_combinations <- analysis_data %>%
    distinct(Country, Region, Code, Date, Sex, Age, AgeInt) %>%
    nrow()
  expect_gt(unique_combinations, 0)  # Ensure there are some unique combinations
})

# Test 5: Check for inconsistencies in categorical columns
test_that("Categorical columns have expected unique values", {
  category_checks <- analysis_data %>%
    summarise(
      Unique_Countries = n_distinct(Country),
      Unique_Regions = n_distinct(Region),
      Unique_Codes = n_distinct(Code),
      Unique_Sexes = n_distinct(Sex)
    )
  expect_gt(category_checks$Unique_Countries, 0)
  expect_gt(category_checks$Unique_Regions, 0)
  expect_gt(category_checks$Unique_Codes, 0)
  expect_gt(category_checks$Unique_Sexes, 0)
})

# Test 6: Check distributions for numerical data
test_that("Distributions of numerical data are within expected ranges", {
  expect_true(mean(analysis_data$Cases, na.rm = TRUE) >= 0)
  expect_true(mean(analysis_data$Deaths, na.rm = TRUE) >= 0)
  expect_true(mean(analysis_data$Tests, na.rm = TRUE) >= 0)
})
