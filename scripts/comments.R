# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# qualtrics and html resources
source("scripts/html_qualtrics_codes.R")

# names
long_name <- "comments"
short_name <- "comm"

# read file
comments <- 
  "materials/comments/input/comments.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\n$", "", .)
# convert linebreaks to html
comments <- 
  comments %>% 
  gsub("\n", "<br>", .) # replace linebreaks with html format linebreaks

# add font size html format
comments <- 
  html_codes$question_font_size %>% 
  str_replace(string = ., 
              pattern = "QUESTION_TEXT_TO_FORMAT", 
              replacement = comments)

# add question format and id
consent_out <-
  paste(qualtrics_codes$question_textentry_essay,
        qualtrics_codes$question_id,
        comments, sep = "\n") %>% 
  str_replace_all(string = ., 
                  pattern = "question_id", 
                  replacement = paste0(short_name, "_", sprintf("%02d", length(.))))

# ourput dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/", long_name) %T>% 
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

comments %>% 
  gsub("<span.*?>", "", .) %>% 
  gsub("</span*?>", "", .) %>% 
  gsub("<br>", "  \n", .) %>% 
  paste(., collapse = "  \n  \n") %>% 
  cat()
  
  
  
  
  
