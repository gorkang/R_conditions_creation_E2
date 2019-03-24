# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# get this scale info
this_scale <- 
  scale_names %>% filter(long_name == "probabilistic_reasoning_scale")

# Names
long_name <- this_scale$long_name
short_name <- this_scale$short_name

# Template reading and handling
probabilistic_reasoning_items <-
  paste0("materials/Scales/input/", long_name,".txt") %>%
  readChar(., file.size(.)) %>% # Read text file
  str_split(., "\n__QSEP__\n") %>% # Separate questions
  unlist() %>% as.list() # Flatten questions list

# RENAME INSTRUCTIONS ID
probabilistic_reasoning_items[[1]] <- 
  probabilistic_reasoning_items[[1]] %>% gsub("replaceID", paste0(short_name, "_ins"), .)
# RENAME ITEMS ID
probabilistic_reasoning_items[str_detect(probabilistic_reasoning_items, "replaceID")] <- 
  probabilistic_reasoning_items[str_detect(probabilistic_reasoning_items, "replaceID")] %>% 
  str_replace(string = ., 
              pattern = "replaceID", 
              replacement = paste0(short_name, "_", sprintf("%02d", seq(sum(str_count(string = ., pattern = "replaceID"))))))
# ADD FONT SIZE
probabilistic_reasoning_items <- 
  probabilistic_reasoning_items %>% 
  gsub("Q_FONT_SIZE", question_size, .) %>% # Change Questions Font size
  gsub("C_FONT_SIZE", choice_size, .) # Change Choices Font size

# Output dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/scales/", long_name) %T>% 
  dir.create(., FALSE, TRUE)

# Export
probabilistic_reasoning_items %>%
  paste(., collapse = paste0('\n', qualtrics_codes$pagebreak, '\n')) %>% 
  cat(qualtrics_codes$advanced_format, 
      gsub("block_name", long_name, qualtrics_codes$block_start),
      ., 
      sep = "\n", file = file.path(output_dir, paste0(long_name ,".txt")))