# ==============================================================================
# Script Name: 2.3_excel_to_csv.R — Excel to CSV Batch Converter
# Author:      Ibraheem Saqib Ellahi <ibraheemsaqib90@gmail.com>
# Purpose:     Convert every .xlsx/.xls dropped into 1_data/ to .csv (first
#              sheet), so templates only ever read CSV. Run automatically at
#              the start of the master knit; safe to source standalone.
# ==============================================================================
library(readxl)
library(readr)
library(tools)
library(here)

# Define the drop zone
data_dir <- here::here("1_data")

# Find all Excel files in the data directory
excel_files <- list.files(path = data_dir, pattern = "\\.xlsx?$|\\.xls$", full.names = TRUE)

if(length(excel_files) > 0) {
  message(paste("Found", length(excel_files), "Excel file(s). Converting to CSV..."))
  
  for(file in excel_files) {
    # Extract the base name without the extension (e.g., "master_macro_panel")
    base_name <- file_path_sans_ext(basename(file))
    
    # Define the new CSV path
    csv_path <- file.path(data_dir, paste0(base_name, ".csv"))
    
    # Read the first sheet of the Excel file and write it as a CSV
    # suppressMessages keeps the console clean during the automated run
    suppressMessages({
      temp_data <- read_excel(file, sheet = 1)
      write_csv(temp_data, csv_path)
    })
    
    message(paste("  - Successfully converted:", basename(file), "->", basename(csv_path)))
  }
  message("All Excel files converted. Ready for rendering.")
} else {
  message("No Excel files found in /1_data. Proceeding with existing CSVs.")
}