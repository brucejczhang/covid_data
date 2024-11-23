#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


# Load required libraries
library(httr)
library(here)

# Set up directories
data_dir <- here("data")
if (!dir.exists(data_dir)) dir.create(data_dir)

# Define data source
data_url <- "https://osf.io/43ucn/download"
output_file <- file.path(data_dir, "raw_data.csv")

# Download the data
if (!file.exists(output_file)) {
  tryCatch({
    download.file(data_url, destfile = output_file, mode = "wb")
    message("Data downloaded successfully.")
  }, error = function(e) {
    stop("Error in downloading the data: ", e$message)
  })
} else {
  message("File already exists. Skipping download.")
}

# Verify the download
if (file.exists(output_file) && file.info(output_file)$size > 0) {
  message("File downloaded and verified.")
} else {
  stop("Failed to download or verify the file.")
}

# Log the download
download_log <- file.path(data_dir, "download_log.txt")
cat(
  paste(Sys.time(), "- Downloaded:", output_file, "\n"),
  file = download_log,
  append = TRUE
)


#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
Data <- read.csv(output_file)

write_csv(Data, "data/01-raw_data/raw_data.csv") 

         
