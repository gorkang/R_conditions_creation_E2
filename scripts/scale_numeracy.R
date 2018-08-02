# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# Template reading and handling
apriori_scale <-
  "materials/Scales/input/numeracy.txt" %>% 
  readChar(., file.size(.)) %>% # Read text file
  str_split(., "\n__QSEP__\n") %>% # Separate questions
  unlist() %>% as.list() %>% # Flatten questions list
  str_replace_all(., "replaceID", paste0("num_0", seq(length(.)))) %>% # Add question IDs
  gsub("Q_FONT_SIZE", question_size, .) %>% # Change Questions Font size
  gsub("C_FONT_SIZE", choice_size, .) # Change Choices Font size

# Output dir
output_dir <- 
  "materials/qualtrics/output/plain_text/scales/numeracy" %T>% 
  dir.create(., FALSE, TRUE)

# Export
apriori_scale %>%
  cat(qualtrics_codes$advanced_format, qualtrics_codes$block_start %>% gsub("block_name", "numeracy", .),
      ., sep = "\n", 
      file = file.path(output_dir, "numeracy.txt"))

