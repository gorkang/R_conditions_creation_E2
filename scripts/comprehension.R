# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

short_name <- "com"

# Qualtrics tags template to wrapp around
# Instructions
ins_wrapper <- 
  '[[Question:Text]]\n[[ID:replaceID]]\n<span style="font-size:Q_FONT_SIZEpx;">ITEM</span>'
# items
item_wrapper <- 
  '[[Question:MC:SingleAnswer:Horizontal]]
[[ID:replaceID]]
<span style="font-size:Q_FONT_SIZEpx;">ITEM</span>
[[Choices]]
<span style="font-size:0px;">delete_this</span>'

# see what's going on.
# item_wrapper %>% cat()

# read items
comprehension <- 
  paste0("materials/Question/Comprehension/input/comprehension.txt") %>%
  readChar(., file.size(.)) %>% 
  gsub("\\n$", "", .) %>% 
  str_split(., "\\n") %>% 
  unlist()

# Wrapping -----------------------------------------------------------

# instructions
comprehension <-
  c(gsub("ITEM", comprehension[1], ins_wrapper),                   # instructions
    str_replace_all(item_wrapper, "ITEM", comprehension[-1])) %>%  # items
  
  str_replace_all(string = ., pattern = "replaceID",  # put question IDs
                  replacement = c(paste0(short_name, "_ins"), paste0(short_name, "_Q", sprintf("%02d", seq(length(.)-1)), "_0"))) %>% 
  
  gsub("Q_FONT_SIZE", 22, .) %>% # Change Questions Font size
  gsub("C_FONT_SIZE", 16, .)       # Change choice Font size

# Export ---------------------------------------------------------------

# Output dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/comprehension") %T>% 
  dir.create(., FALSE, TRUE)

# print text file
comprehension %>% 
  paste(., collapse = "\n") %>%
  cat(., file = file.path(output_dir, "comprehension.txt"))
