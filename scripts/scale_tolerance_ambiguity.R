# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# Apparently, only tags without numbers are used in the first article without middle point. Also, omissions were
# scored as 4.
# # strong agreement was scored (7)
# # moderate agreement          (6)
# # slight agreement            (5)
# # slight disagreement         (3)
# # moderate disagreement       (2)
# # strong disagreement         (1)
# ITEMS ARE RANDOMLY PRESENTED

# names for item ID
long_name <- "tolerance_ambiguity"
short_name <- "ta"

# qualtrics tags template to wrapp around
# instructions
ins_wrapper <- '[[Question:Text]]\n[[ID:replaceID]]\n<span style="font-size:Q_FONT_SIZEpx;">ITEM</span>'
# items
item_wrapper <- 
  '[[Question:MC:SingleAnswer:Horizontal]]
[[ID:replaceID]]
<span style="font-size:Q_FONT_SIZEpx;">ITEM</span>
[[Choices]]
<span style="font-size:C_FONT_SIZEpx;">Disagree Strongly</span>
<span style="font-size:C_FONT_SIZEpx;">Disagree Moderately</span>
<span style="font-size:C_FONT_SIZEpx;">Disagree Slightly</span>
<span style="font-size:C_FONT_SIZEpx;">Agree Slightly</span>
<span style="font-size:C_FONT_SIZEpx;">Agree Moderately</span>
<span style="font-size:C_FONT_SIZEpx;">Agree Strongly</span>'
# see what's going on.
# item_wrapper %>% cat()

# read items
big5_items <- 
  "materials/Scales/input/big_five.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\\n$", "", .) %>% 
  str_split(., "\\n") %>% 
  unlist()

# Wrapping
# instructions
ins <- gsub("ITEM", big5_items[1], ins_wrapper)
# items
items <- str_replace_all(item_wrapper, "ITEM", big5_items[-1])

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
