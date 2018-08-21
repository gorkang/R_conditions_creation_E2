# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# qualtrics and html resources
source("scripts/html_qualtrics_codes.R")

# names
long_name <- "consent_form"
short_name <- "consent"

# read file
consent <- 
  "materials/consent_form/input/consent_form.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\n$", "", .)
# separate pages in a vector
consent <- 
  consent %>% 
  str_split(., "\n__SEP__\n") %>% 
  unlist() %>% 
  gsub("\n", "<br>", .) # replace linebreaks with html format linebreaks

# add font size html format
consent <- 
  html_codes$question_font_size %>% 
  str_replace(string = ., 
              pattern = "QUESTION_TEXT_TO_FORMAT", 
              replacement = consent)

# add question format and id
consent_out <-
  paste(qualtrics_codes$question_only_text,
        qualtrics_codes$question_id,
        consent, sep = "\n") %>% 
  str_replace_all(string = ., 
                  pattern = "question_id", 
                  replacement = paste0(short_name, "_", sprintf("%02d", 1:2)))

# ourput dir
output_dir <- 
  "materials/qualtrics/output/plain_text/consent_form" %T>% 
  dir.create(., FALSE, TRUE)

# export to text file
consent_out %>% 
  paste(., collapse = paste0("\n", qualtrics_codes$pagebreak, "\n")) %>%
  paste(qualtrics_codes$advanced_format,
        gsub("block_name", long_name, qualtrics_codes$block_start),
        .,
        sep = "\n") %>% 
  cat(., file = file.path(output_dir, paste0(long_name, ".txt")))


# Print consent -----------------------------------------------------------
source("functions/remove_placeholders.R")

consent %>% 
  gsub("<span.*?>", "", .) %>% 
  gsub("</span*?>", "", .) %>% 
  gsub("<br>", "  \n", .) %>% 
  paste(., collapse = "  \n  \n") %>% 
  cat()
  
  
  
  
  
