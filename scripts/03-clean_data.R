#### Preamble ####
# Purpose: Cleans the raw data on COVID-19 to only contain data for Canada and removes unecessary data
# Author: Bruce Zhang
# Date: 25 November 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# Any other information needed? Make sure you are in the `COVID_demographics` rproj

# Load necessary libraries
library(dplyr)
library(tidyr)
library(tidyverse)
library(arrow)

# Step 1: Remove unnecessary columns (if applicable)
data_cleaned <- simulated_data %>%
  select(Country, Region, Date, Sex, Age, Cases, Deaths, Tests)

# Step 2: Handle missing values
# Replace missing numeric values with 0
data_cleaned <- data_cleaned %>%
  mutate(
    Cases = ifelse(is.na(Cases), 0, Cases),
    Deaths = ifelse(is.na(Deaths), 0, Deaths),
    Tests = ifelse(is.na(Tests), 0, Tests)
  )

# Step 3: Format dates
data_cleaned <- data_cleaned %>%
  mutate(
    # Ensure Date is in proper date format
    Date = as.Date(Date, format = "%d.%m.%Y"),
  )


# Step 4: Ensure consistent data types
data_cleaned <- data_cleaned %>%
  mutate(
    Country = as.factor(Country),
    Region = as.factor(Region),
    Sex = as.factor(Sex),
    Age = as.numeric(Age),
    Cases = as.numeric(Cases),
    Deaths = as.numeric(Deaths),
  )

# Step 5: Remove duplicate rows
data_cleaned <- data_cleaned %>%
  distinct() %>%
  filter(Country == "Canada") %>%
  filter(Region %in% c("Urban", "Rural"), Sex %in% c("m", "f"))

# Step 6: Check for and handle outliers
data_cleaned <- data_cleaned %>%
  mutate(
    Cases = ifelse(Cases > 100000, 100000, Cases),
    Deaths = ifelse(Deaths > 1000, 1000, Deaths),
    Tests = ifelse(Tests > 500000, 500000, Tests)
  )

data_cleaned <- data_cleaned %>%
  filter(Deaths <= Cases)

# Step 7: Add calculated columns
# Case Fatality Rate (CFR)
data_cleaned <- data_cleaned %>%
  mutate(CFR = ifelse(Cases > 0, (Deaths / Cases) * 100, NA))

# Summary of cleaned data
summary(data_cleaned)

#### Save data ####
analysis_data <- write_parquet(data_cleaned, "data/02-analysis_data/analysis_data.parquet")
