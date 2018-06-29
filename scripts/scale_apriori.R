# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# Template reading and handling
apriori_scale <- 
  "materials/Scales/input/a_priori_screening_beliefs.txt" %>% 
  readChar(., file.size(.)) %>% # Read text file
  str_split(., "\n__QSEP__\n") %>% # Separate questions
  unlist() %>% as.list() %>% # Flatten questions list
  str_replace_all(., "replaceID", paste0("aprioriBel_0", seq(length(.)))) %>% # Add question IDs
  gsub("Q_FONT_SIZE", "22", .) %>% # Change Questions Font size
  gsub("C_FONT_SIZE", "16", .) # Change Choices Font size

# Output dir
output_dir <- 
  "materials/qualtrics/output/plain_text/scales/apriori_belief" %T>% 
  dir.create(., FALSE, TRUE)
# Export
apriori_scale %>% 
  cat(qualtrics_codes$advanced_format, ., sep = "\n", 
      file = file.path(output_dir, "scale_apriori_belief.txt"))

