# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# get this scale info
this_scale <- 
  scale_names %>% filter(long_name == "shared_decision_making")

# Names
long_name <- this_scale$long_name
short_name <- this_scale$short_name

# read scale template (already with Qualtrics tags) 
scale_template <-  
  "materials/Scales/input/shared_decision_making_style.txt" %>%  
  readChar(., file.size(.)) 

# Indicate questions and choices size 
scale_template <-  
  scale_template %>% gsub("Q_FONT_SIZE", question_size, .) %>% gsub("C_FONT_SIZE", choice_size, .) 
scale_template %>% cat()

# Add advance format tag, block tag (and name)
scale_template <- 
  paste(qualtrics_codes$advanced_format, 
        gsub("block_name", long_name, qualtrics_codes$block_start),
        scale_template, sep = "\n")

# Export
# create folder
export_path <- 
  file.path("materials/qualtrics/output/plain_text/scales", long_name) %T>% 
  dir.create(., FALSE, TRUE) 

scale_template %>% 
  cat(., sep = "\n", file = file.path(export_path, paste0(long_name, ".txt")))
