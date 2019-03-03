# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# qualtrics and html resources
source("scripts/html_qualtrics_codes.R")

# dir to ins
ins_dir <- 'materials/scales_instructions'

# ins files 
ins_files <- 
  ins_dir %>% 
  dir(.)

# ins text
ins <-
  file.path(ins_dir, ins_files) %>% 
  map(., ~readChar(.x, file.size(.x))) %>% 
    gsub('\n$', '', .) %>% gsub('\n', '<br>', .)

# Add qualtrics question type and question id tags 
ins_formatted <- 
  paste(qualtrics_codes$advanced_format,
        qualtrics_codes$block_start,
        qualtrics_codes$question_only_text,
        qualtrics_codes$question_id,
        ins,
        sep = '\n') %>% 
  str_replace_all(string = ., pattern = 'question_id', replacement = gsub('.txt', '', ins_files)) %>% 
  str_replace_all(string = ., pattern = 'block_name', replacement = gsub('.txt', '', ins_files))

# Export scale titles and instructions to text files
ins_formatted %>% 
  walk(., ~cat(.x, 
               file = file.path('materials/qualtrics/output/plain_text/scales_instructions', 
                                # Get file name from question id
                                paste0(gsub('.*ID\\:(.*)\\]{2}.*', '\\1', .x), '.txt'))))


# Print scale instructions -----------------------------------------------------------
source("functions/remove_placeholders.R")

ins_formatted %>% 
  gsub("<.*?g>", "", .) %>% 
  gsub("\\[{2}.*?\\]{2}\n", "", .) %>% 
  gsub("<span.*?>", "", .) %>% 
  gsub("</span*?>", "", .) %>% 
  gsub("<br>", "  \n", .) %>% 
  paste(., collapse = "  \n  \n") %>% 
  cat()

