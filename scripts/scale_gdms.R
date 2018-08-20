# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# names for item ID
long_name <- "general_decision_making_style_scale"
short_name <- "gdms"

# qualtrics tags template to wrapp around
# Instructions
ins_wrapper <- 
'[[Question:Text]]
[[ID:replaceID]]
<span style="font-size:Q_FONT_SIZEpx;">ITEM</span>'
# Items
item_wrapper <- 
'[[Question:MC:SingleAnswer:Horizontal]]
[[ID:replaceID]]
<span style="font-size:Q_FONT_SIZEpx;">ITEM</span>'
# Choices
choices <- 
'[[Choices]]
<span style="font-size:C_FONT_SIZEpx;">1<br>strongly disagree</span>
<span style="font-size:C_FONT_SIZEpx;">2<br> </span>
<span style="font-size:C_FONT_SIZEpx;">3<br> </span>
<span style="font-size:C_FONT_SIZEpx;">4<br> </span>
<span style="font-size:C_FONT_SIZEpx;">5<br>strongly agree</span>'

# see what's going on.
# item_wrapper %>% cat()
# choices_wrapper %>% cat()

# read items
gdsm_items <- 
  "materials/Scales/input/gdms.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\\n$", "", .) %>% 
  str_split(., "\\n") %>% 
  unlist()

# Wrapping
# instructions
ins <- gsub("ITEM", gdsm_items[1], ins_wrapper)
# items
items <- str_replace_all(item_wrapper, "ITEM", gdsm_items[-1]) %>% paste0(., "\n", choices)

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
      sep = "\n", 
      file = file.path(output_dir, paste0(long_name, ".txt")))
