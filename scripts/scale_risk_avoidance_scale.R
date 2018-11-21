# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# get this scale info
this_scale <- 
  scale_names %>% filter(long_name == "risk_avoidance_scale")

# Names
long_name <- this_scale$long_name
short_name <- this_scale$short_name

# qualtrics tags template to wrapp around
# instructions
ins_wrapper <- "[[Question:Text]]\n[[ID:replaceID]]\n<span style='font-size:Q_FONT_SIZEpx;'>ITEM</span>"
# items
item_wrapper <- 
  "[[Question:MC:SingleAnswer:Horizontal]]
[[ID:replaceID]]
<span style='font-size:Q_FONT_SIZEpx;'>ITEM</span>
[[Choices]]
<span style='font-size:C_FONT_SIZEpx;'>1<br>Yes</span>
<span style='font-size:C_FONT_SIZEpx;'>2<br>Cannot decide</span>
<span style='font-size:C_FONT_SIZEpx;'>3<br>No</span>"
# see what's going on.
# item_wrapper %>% cat()

# read items
ras_items <- 
  paste0("materials/Scales/input/", long_name,".txt") %>%
  readChar(., file.size(.)) %>% 
  gsub("\\n$", "", .) %>% 
  str_split(., "\\n") %>% 
  unlist()

# Wrapping
# instructions
ins <- gsub("ITEM", ras_items[1], ins_wrapper)
# items
items <- str_replace_all(item_wrapper, "ITEM", ras_items[-1])

# Output dir
output_dir <- 
  paste0("materials/qualtrics/output/plain_text/scales/", long_name) %T>%
  dir.create(., FALSE, TRUE)

# build and export scale
c(ins, items) %>% 
  gsub("Q_FONT_SIZE", question_size, .) %>% # Change Questions Font size
  gsub("C_FONT_SIZE", choice_size, .) %>%  # Change Choices Font size
  str_replace_all(string = ., 
                  pattern = "replaceID", 
                  replacement = c(paste0(short_name, "_ins"), paste0(short_name, "_", sprintf("%02d", seq(length(.)-1))))) %>% 
  cat(qualtrics_codes$advanced_format, 
      gsub("block_name", long_name, qualtrics_codes$block_start), ., 
      sep = "\n", file = file.path(output_dir, paste0(long_name ,".txt")))
