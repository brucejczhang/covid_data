#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

install.packages("tidyr")
# Load necessary libraries
library(dplyr)
library(tidyr)
library(tidyverse)

# Step 1: Remove unnecessary columns (if applicable)
data_cleaned <- simulated_data %>%
  select(Country, Region, Date, Sex, Age, Cases, Deaths, Tests)

# Step 2: Handle missing values
# Replace missing numeric values with 0 (if appropriate)
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
    
    # Extract year as a numeric variable
    Year = as.numeric(format(Date, "%Y")),
    
    # Convert Date into a continuous variable (number of days since 1970-01-01)
    Date_Continuous = as.numeric(Date)
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
    Tests = as.numeric(Tests)
  )

# Remove duplicate rows (if any)
data_cleaned <- data_cleaned %>%
  distinct()

# Check for and handle outliers (optional)
# For example, cap unrealistic values for 'Cases', 'Deaths', or 'Tests'
data_cleaned <- data_cleaned %>%
  mutate(
    Cases = ifelse(Cases > 100000, 100000, Cases),
    Deaths = ifelse(Deaths > 1000, 1000, Deaths),
    Tests = ifelse(Tests > 500000, 500000, Tests)
  )

# Add calculated columns (if needed)
# Example: Case Fatality Rate (CFR)
data_cleaned <- data_cleaned %>%
  mutate(CFR = ifelse(Cases > 0, (Deaths / Cases) * 100, NA))

# Summary of cleaned data
summary(data_cleaned)

#### Save data ####
analysis_data <- write_csv(data_cleaned, "data/02-analysis_data/analysis_data.csv")
