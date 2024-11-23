#### Preamble ####
# Purpose: Simulates a dataset of COVID cases and deaths relative to demographics and geographic location. 
# Author: Bruce Zhang
# Date: 21 November 2024
# Contact: brucejc.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `COVID_demographics` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(21)

# Define parameters
countries <- c("Afghanistan", "Brazil", "Canada", "Denmark", "Egypt")
regions <- c("All", "Urban", "Rural")
codes <- c("AF", "BR", "CA", "DK", "EG")
dates <- seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "1 month")
sexes <- c("b", "m", "f")
ages <- seq(0, 100, by = 10)
age_int <- 10

# Generate the data
simulated_data <- expand.grid(
  Country = countries,
  Region = regions,
  Code = codes,
  Date = dates,
  Sex = sexes,
  Age = ages,
  AgeInt = age_int
)

# Add random values for Cases, Deaths, and Tests
simulated_data$Cases <- round(runif(nrow(simulated_data), min = 0, max = 20000))
simulated_data$Deaths <- round(runif(nrow(simulated_data), min = 0, max = 500))
simulated_data$Tests <- round(runif(nrow(simulated_data), min = 100, max = 50000))

# Display a sample of the simulated data
head(simulated_data)

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
