#### Preamble ####
# Purpose: Tests the analysis data for any potential problems that may compromise the analysis. 
# Author: Bruce Zhang
# Date: 23 September 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
 # - 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `COVID_demographics` rproj


# Load necessary libraries
library(dplyr)
library(ggplot2)

# Test the integrity of the analysis dataset
message("Testing the analysis data...")

# Step 1: Load the data
# Replace 'analysis_data_path' with the actual path to your data file
analysis_data_path <- "data/02-analysis_data/analysis_data.csv"
analysis_data <- read.csv(analysis_data_path)

# Step 2: Basic Structure and Preview
message("Previewing the dataset...")
print(head(analysis_data))
print(str(analysis_data))

# Step 3: Check for Missing Values
message("Checking for missing values...")
missing_summary <- analysis_data %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Missing_Count")

print(missing_summary)

# Step 4: Check for Duplicates
message("Checking for duplicate rows...")
duplicates <- analysis_data %>%
  duplicated() %>%
  sum()
message(paste("Number of duplicate rows:", duplicates))

# Step 5: Summary Statistics
message("Generating summary statistics...")
summary_statistics <- analysis_data %>%
  summarise(
    Total_Regions = n_distinct(Region),
    Total_Countries = n_distinct(Country),
    Total_Sexes = n_distinct(Sex),
    Total_Ages = n_distinct(Age),
    Total_Cases = sum(Cases, na.rm = TRUE),
    Total_Deaths = sum(Deaths, na.rm = TRUE),
    Total_Tests = sum(Tests, na.rm = TRUE)
  )
print(summary_statistics)

# Step 6: Validate Key Columns
message("Validating key columns...")

# Check unique values in categorical columns
region_values <- unique(analysis_data$Region)
sex_values <- unique(analysis_data$Sex)
message("Regions present in the data: ", paste(region_values, collapse = ", "))
message("Sex categories present in the data: ", paste(sex_values, collapse = ", "))

# Ensure no invalid values in Region or Sex
valid_regions <- c("Urban", "Rural", "All")
valid_sexes <- c("m", "f", "b")
invalid_regions <- setdiff(region_values, valid_regions)
invalid_sexes <- setdiff(sex_values, valid_sexes)
if (length(invalid_regions) > 0) {
  warning("Invalid Region values found: ", paste(invalid_regions, collapse = ", "))
}
if (length(invalid_sexes) > 0) {
  warning("Invalid Sex values found: ", paste(invalid_sexes, collapse = ", "))
}

# Step 7: Check for Logical Errors
message("Checking for logical errors...")

# Cases, Deaths, and Tests should not be negative
negative_values <- analysis_data %>%
  filter(Cases < 0 | Deaths < 0 | Tests < 0)
if (nrow(negative_values) > 0) {
  warning("Negative values found in Cases, Deaths, or Tests:")
  print(negative_values)
}

# Deaths should not exceed Cases
invalid_death_cases <- analysis_data %>%
  filter(Deaths > Cases)
if (nrow(invalid_death_cases) > 0) {
  warning("Deaths exceed Cases in the following rows:")
  print(invalid_death_cases)
}

# Step 8: Visualize Key Distributions
message("Visualizing key distributions...")

# Cases by Region
ggplot(analysis_data, aes(x = Region, y = Cases, fill = Region)) +
  geom_boxplot(alpha = 0.6) +
  labs(title = "Distribution of Cases by Region", x = "Region", y = "Number of Cases") +
  theme_minimal()

# Deaths by Age
# Create a histogram of deaths by age
ggplot(analysis_data, aes(x = Age, weight = Deaths)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black", alpha = 0.7) +
  labs(
    title = "Distribution of Deaths by Age",
    x = "Age",
    y = "Number of Deaths"
  ) +
  theme_minimal()


# Step 9: Testing Complete
message("Analysis data testing completed successfully!")
