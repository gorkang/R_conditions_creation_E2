# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# get this scale info
this_scale <- 
  scale_names %>% filter(long_name == "sociodemographic_scale")

# Names
long_name <- this_scale$long_name
short_name <- this_scale$short_name

# Read scale
sociodemo <- 
  paste0("materials/Scales/input/", long_name,".txt") %>%
  readChar(., file.size(.)) %>% # Read text file
  str_split(., "\n__QSEP__\n") %>% # Separate questions
  unlist()

# IDs and font size
sociodemo <- 
  sociodemo %>% 
  str_replace_all(string = ., pattern = "replaceID", replacement = paste0(short_name, "_", c("gen", "age", "edu", "lan", "nat"))) %>% 
  gsub("Q_FONT_SIZE", question_size, .) %>% # Change Questions Font size
  gsub("C_FONT_SIZE", choice_size, .) # Change Choices Font size


# Output dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/scales/", long_name) %T>% 
  dir.create(., FALSE, TRUE)

# Export
sociodemo %>% 
  paste(., collapse = "\n") %>% 
  cat(qualtrics_codes$advanced_format,
      gsub("block_name", long_name, qualtrics_codes$block_start),
      ., sep = "\n", file = file.path(output_dir, paste0(long_name, ".txt")))