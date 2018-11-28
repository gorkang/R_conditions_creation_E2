# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# qualtrics and html resources
source("scripts/html_qualtrics_codes.R")

# Names
long_name <- "previous_experience"
short_name <- "prevExp"

# read file
previous_experience <- 
  "materials/previous_experience/previous_experience.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\n$", "", .)
# separate questions
previous_experience <- 
  previous_experience %>% 
  gsub("Q_FONT_SIZE", question_size, .) %>% # Change Questions Font size
  gsub("C_FONT_SIZE", choice_size, .) %>%  # Change Choices Font size
  str_split(., "\n__QSEP__\n") %>% 
  unlist()

# add question format and id
previous_experience <-
  previous_experience %>% 
  str_replace_all(string = ., 
                  pattern = "replaceID", 
                  replacement = paste0(short_name, "_", sprintf("%02d", seq(length(.))))) %>% 
  paste(., collapse = "\n")

# ourput dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/", long_name) %T>% 
  dir.create(., FALSE, TRUE)

# export to text file
previous_experience %>% 
  paste(qualtrics_codes$advanced_format, 
        gsub("block_name", long_name, qualtrics_codes$block_start), 
        ., sep = "\n") %>% 
  cat(., file = file.path(output_dir, paste0(long_name, ".txt")))

# Print consent -----------------------------------------------------------
source("functions/remove_placeholders.R")

previous_experience %>% 
  gsub("\\[{2}.*?\\]{2}\n", "", .) %>%
  gsub("\\?", "?__", .) %>% 
  gsub(">W", ">__W", .) %>%
  gsub("<span.*?>", "", .) %>% 
  gsub("</span>", "", .) %>% 
  gsub("<br>", "  \n", .) %>% 
  paste(., collapse = "  \n  \n") %>% 
  cat()
