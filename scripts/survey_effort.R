# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# qualtrics and html resources
source("scripts/html_qualtrics_codes.R")

# names
long_name <- "survey_effort"
short_name <- "eff"

# read file
survey_effort <- 
  "materials/survey_effort/survey_effort.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\n$", "", .) %>% 
  str_split(., "\n__SEP__\n") %>% 
  unlist()

# add font size
survey_effort <- 
  survey_effort %>% 
  gsub("Q_FONT_SIZE", "22", .) %>% 
  gsub("C_FONT_SIZE", "16", .)

# add question format and id
survey_effort <-
  survey_effort %>% 
  str_replace(string = ., 
                  pattern = "replaceID", 
                  replacement = paste0(short_name, "_", sprintf("%02d", seq(length(.)))))

# ourput dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/", long_name) %T>% 
  dir.create(., FALSE, TRUE)

# export to text file
survey_effort %>% 
  paste(., collapse = "\n") %>% 
  paste(qualtrics_codes$advanced_format,
        gsub("block_name", long_name, qualtrics_codes$block_start),
        .,
        sep = "\n") %>% 
  cat(., file = file.path(output_dir, paste0(long_name, ".txt")))


# Print consent -----------------------------------------------------------
source("functions/remove_placeholders.R")

survey_effort %>% 
  gsub("\\[{2}.*?\\]{2}\n", "", .) %>% 
  gsub("<span.*?>", "", .) %>% 
  gsub("</span*?>", "", .) %>% 
  gsub("<br>", "  \n", .) %>% 
  paste(., collapse = "  \n  \n") %>% 
  cat()
  
  
  
  
  
