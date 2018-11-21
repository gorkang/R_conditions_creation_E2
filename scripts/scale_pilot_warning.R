# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# Nombre
long_name <- "pilot_warning"
short_name <- "pilotWar"

# Read scale
pilot_warning <- 
  "materials/pilot_warning/input/pilot_warning.txt" %>% 
  readChar(., file.size(.)) %>% # Read text file
  gsub("\n$", "", .) %>% 
  gsub("\n", "<br>", .) %>% 
  str_split(., "\n__QSEP__\n") %>% # Separate questions
  unlist()

# Add font size  html tag
pilot_warning <- 
  html_codes$question_font_size %>% 
  str_replace(string = ., 
              pattern = "QUESTION_TEXT_TO_FORMAT", 
              replacement = pilot_warning)

# Add question format
pilot_warning_out <- 
  paste(qualtrics_codes$question_only_text,
        qualtrics_codes$question_id,
        pilot_warning, sep = "\n") %>% 
  str_replace_all(string = ., 
                  pattern = "question_id", 
                  replacement = short_name)

# Create output dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/", long_name) %T>% 
  dir.create(., FALSE, TRUE)

# Export
pilot_warning_out %>% 
  cat(qualtrics_codes$advanced_format,
      gsub("block_name", long_name, qualtrics_codes$block_start),
      ., sep = "\n", file = file.path(output_dir, paste0(long_name, ".txt")))
