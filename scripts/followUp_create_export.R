# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# functions
source("functions/remove_placeholders.R")
source("functions/followup_question_builder.R")
source("functions/choice_builder.R")
source("functions/extract_between_placeholders.R")
source("functions/questionIDme.R")
# resources
source("scripts/html_qualtrics_codes.R")

# Generic follow-up template
unified_fu <-
  "materials/Question/Follow_up/input/items/unified_fu.txt" %>% 
  readChar(., file.size(.)) 

# Create follow-up questions
path2fu_raw_questions              <- "materials/Question/Follow_up/input/questions_raw/"

# Read follow-up questions
fu_questions <-
  dir(path2fu_raw_questions, ".txt") %>% 
  map(~followup_question_builder(file_path = path2fu_raw_questions, 
                                 file_name = .x, 
                                 export = FALSE
  )) %>% unlist()
# Collapse followup questions (Add pagebreaks)
fu_questions <-
  paste(fu_questions[1], 
        qualtrics_codes$pagebreak, 
        paste(fu_questions[2], collapse = "\n"), 
        qualtrics_codes$pagebreak,
        paste(fu_questions[3], collapse = "\n"), 
        qualtrics_codes$pagebreak,
        paste(fu_questions[4], collapse = "\n"), 
        qualtrics_codes$pagebreak,
        paste(fu_questions[5:8], collapse = "\n"), 
        sep = "\n")

# 
unified_fu_questions <-
  unified_fu %>% 
  gsub("\\n$", "", .) %>%                                              # remove last linebreak
  gsub("\\n", "<br>", .) %>%                                             # replace remaining linebreaks with html linebreaks
  gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) %>%  # add html code to follow-up text
  paste(qualtrics_codes$question_only_text,         # paste qualtrics tags with follow-up text and follow-up questions
        questioIDme("fu_ins_0"),
        ., 
        fu_questions, sep = "\n")

# remove linebreak between list elements
unified_fu_questions %<>% 
  gsub("(li>)<br>(<li)", "\\1\\2", .)

# Output dir
fu_output_dir <- 
  "materials/qualtrics/output/plain_text/followup/" %T>% 
  dir.create(., showWarnings = FALSE, recursive = TRUE) 
# export complete followup (item + questions)
unified_fu_questions %>% 
  cat(., file = "materials/qualtrics/output/plain_text/followup/fu_unified.txt")

# PRINT FOLLOWUP --------------------------------------------------------------
source("scripts/print_followup.R")

