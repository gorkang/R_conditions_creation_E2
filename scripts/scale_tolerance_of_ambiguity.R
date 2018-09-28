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

# get this scale info
this_scale <- 
  scale_names %>% filter(long_name == "tolerance_of_ambiguity")

# Names
long_name <- this_scale$long_name
short_name <- this_scale$short_name

# Qualtrics tags template to wrapp around
# Instructions
ins_wrapper <- 
  "[[Question:Text]]\n[[ID:replaceID]]\n<span style='font-size:Q_FONT_SIZEpx;'>ITEM</span>"
# Items
item_wrapper <- 
  "[[Question:MC:SingleAnswer:Horizontal]]
[[ID:replaceID]]
<span style='font-size:Q_FONT_SIZEpx;'>ITEM</span>
[[Choices]]
<span style='font-size:C_FONT_SIZEpx;'>Disagree<br>Strongly</span>
<span style='font-size:C_FONT_SIZEpx;'>Disagree<br>Moderately</span>
<span style='font-size:C_FONT_SIZEpx;'>Disagree<br>Slightly</span>
<span style='font-size:C_FONT_SIZEpx;'>Agree<br>Slightly</span>
<span style='font-size:C_FONT_SIZEpx;'>Agree<br>Moderately</span>
<span style='font-size:C_FONT_SIZEpx;'>Agree<br>Strongly</span>"
# see what's going on.
# item_wrapper %>% cat()

# read items
tolerance_ambiguity <- 
  paste0("materials/Scales/input/", long_name,".txt") %>%
  readChar(., file.size(.)) %>% 
  gsub("\\n$", "", .) %>% 
  str_split(., "\\n") %>% 
  unlist()

# Wrapping
# instructions
ins <- gsub("ITEM", tolerance_ambiguity[1], ins_wrapper)
# items
items <- str_replace_all(item_wrapper, "ITEM", tolerance_ambiguity[-1])

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
