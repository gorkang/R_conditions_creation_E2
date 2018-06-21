# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# functions
source("functions/remove_placeholders.R")
source("functions/followup_question_builder.R")
source("functions/choice_builder.R")
source("functions/extract_between_placeholders.R")
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
                                 
  ))

# 
unified_fu_questions <-
  unified_fu %>% 
  remove_placeholders(., item_followup = "followup") %>%                 # remove placeholders
  gsub("^\\n", "", .) %>% 
  gsub("\\n\\b", "", .) %>%
  gsub("\\n", "<br>", .) %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) %>%  # add html code to follow-up text
  paste(qualtrics_codes$advanced_format,                                 # paste qualtrics tags with follow-up text and follow-up questions
        qualtrics_codes$question_only_text, 
        ., 
        paste(unlist(fu_questions), collapse = "\n"), sep = "\n")

# remove linebreak between list elements
unified_fu_questions %<>% 
  gsub("(li>)<br>(<li)", "\\1\\2", .)

# Create trial customized follow-up
trials_no <- 2
fu_trials <- as.list(rep(unified_fu_questions, trials_no))
# Customize follow-up to trials (2 trials)
for (a in seq(trials_no)) {
  # a <- 1
  fu_trials[[a]] <-
    fu_trials[[a]] %>% 
    gsub("([a-z])\\}", paste0("\\1_0", a, "}"), .) %>% 
    paste0("**trial_0", a, "**", .)
}

# Output dir
fu_output_dir <- 
  "materials/qualtrics/output/plain_text/followup/" %T>% 
  dir.create(., showWarnings = FALSE, recursive = TRUE) 

# Export each trial follow-up
fu_trials %>% 
  walk(~cat(gsub("\\*\\*.*\\*\\*", "", .x), sep = "", 
            file = paste0(fu_output_dir, "fu_", gsub("\\*\\*(.*)\\*\\*.*", "\\1", .x), ".txt"))
  )
