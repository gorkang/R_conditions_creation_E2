# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# qualtrics and html resources
source("scripts/html_qualtrics_codes.R")

# names
long_name <- "scales_instructions"
short_name <- "scale_ins"

# read file
scale_instructions <- 
  "materials/scales_instructions/scales_instructions.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\n$", "", .)

# add font size html format
scale_instructions <- 
  html_codes$question_font_size %>% 
  str_replace(string = ., 
              pattern = "QUESTION_TEXT_TO_FORMAT", 
              replacement = scale_instructions)

# add question format and id
scale_instructions <-
  paste(qualtrics_codes$question_only_text,
        qualtrics_codes$question_id,
        scale_instructions, sep = "\n") %>% 
  str_replace_all(string = ., 
                  pattern = "question_id", 
                  replacement = paste0(short_name, "_", sprintf("%02d", 1)))

# ourput dir
output_dir <- 
  "materials/qualtrics/output/plain_text/scales_instructions" %T>% 
  dir.create(., FALSE, TRUE)

# export to text file
scale_instructions %>% 
  paste(., collapse = paste0("\n", qualtrics_codes$pagebreak, "\n")) %>%
  paste(qualtrics_codes$advanced_format,
        gsub("block_name", long_name, qualtrics_codes$block_start),
        .,
        sep = "\n") %>% 
  cat(., file = file.path(output_dir, paste0(long_name, ".txt")))


# Print scale instructions -----------------------------------------------------------
source("functions/remove_placeholders.R")

scale_instructions %>% 
  gsub("\\[{2}.*?\\]{2}\n", "", .) %>% 
  gsub("<span.*?>", "", .) %>% 
  gsub("</span*?>", "", .) %>% 
  gsub("<br>", "  \n", .) %>% 
  paste(., collapse = "  \n  \n") %>% 
  cat()

# Personality/Cognitive block titles ###########################
# titles
pers_title <- 
  "Personality scales" %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", . , html_codes$title_font_size) %>% 
  gsub("STRONGME", ., html_codes$bold)
cog_title <- 
  "Cognitive scales" %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", . , html_codes$title_font_size) %>% 
  gsub("STRONGME", ., html_codes$bold)

# assemble pers title block
paste(qualtrics_codes$advanced_format,
      gsub("block_name", "pers_title", qualtrics_codes$block_start),
      qualtrics_codes$question_only_text,
      questioIDme("pers_title"),
      pers_title, sep = "\n") %>% 
  cat(., file = file.path(output_dir, "pers_title.txt"))

# assemble cog title block
paste(qualtrics_codes$advanced_format,
      gsub("block_name", "cog_title", qualtrics_codes$block_start),
      qualtrics_codes$question_only_text,
      questioIDme("cog_title"),
      cog_title, sep = "\n") %>% 
  cat(., file = file.path(output_dir, "cog_title.txt"))

