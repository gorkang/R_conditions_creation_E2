# TODO: consider what to do with sliders text (if sliders has text before, do a single choice vertical. if not, a simple text only question)
# TODO: what to do with the last follow-up question. has to had a logic display regarding the first follow-up question.

# There are 16 unique(ish) prevalences (2 contexts x 4 formats x 2 ppv prob)
# There are 2 follow-up risk (1%, 10%)
# Therefore, there are 32 possible follow-up items (e.g. ca_nfab_low_high; ppvLow_riskHigh)

# Functions
source("scripts/html_qualtrics_codes.R")
source("functions/extract_between_placeholders.R")
source("functions/choice_builder.R")
source("functions/prev2followup.R")
source("functions/followup_question_builder.R")
source("functions/load_puthtml_export.R")
source("functions/export_qualtrics_followup_items.R")

# ALL PATHS ****************************
path2fu_raw_questions              <- "materials/Question/Follow_up/input/questions_raw/"
path2fu_w_prev                     <- "materials/Question/Follow_up/output/item_w_prevalence/"
path2fu_qualtrics_items            <- "materials/qualtrics/input/followUp/items/"
path2fu_qualtrics_questions        <- "materials/qualtrics/input/followUp/questions/"
path2fu_qualtrics_complete_items   <- "materials/qualtrics/output/followUp/"

# **************************************

# ##################################
# Follow-up questions building
# ##################################

dir(path2fu_raw_questions, ".txt") %>% 
  map(~followup_question_builder(path2fu_raw_questions, .x, path2fu_qualtrics_questions)) %>% 
  invisible()

# ###################################################
# Follow-up item building with unique prevalences
# ###################################################

# function to get unique character within string?
uniqchars <- 
  function(x) unique(strsplit(x, "")[[1]]) 
# get unique characters of possible response types
response_type_regex <-
  dir("materials/Response_type/", pattern = ".txt") %>% 
  gsub("\\.txt", "", .) %>% paste(., collapse = "") %>% 
  uniqchars() %>% paste(., collapse = "")

# This snippet get only names
# unique_prevalences_names <-
#   problems_numbered_ordered_responses[seq(1, length(problems_numbered_ordered_responses), 4)] %>% 
#   map(~gsub(paste0("\\*\\*(.*)_[", response_type_regex, "]{2}\\*\\*(.*)"), "\\1\\2", .x)) %>% unlist

# Get unique prevalences with names
unique_prevalences <- 
  problems_numbered_ordered_responses[seq(1, length(problems_numbered_ordered_responses), 4)] %>% 
  map(~gsub(paste0("(\\*\\*.*)_[", response_type_regex, "]{2}(\\*\\*).*\\[first_piece\\]\\n(.*)\\n\\[second_piece\\].*"), "\\1\\2\\3", .x)) %>% unlist

# create follow-up item with every unique prevalence
unique_prevalences %>% 
  map(~prev2followUp(prevalence_string = .x, 
                     follow_up_dir = "materials/Question/Follow_up/output/item_raw/", 
                     outputdir = "materials/Question/Follow_up/output/item_w_prevalence/", rmv_placeholders = TRUE) ) %>% 
  invisible()

# ###################################################
# Bind follow-up items with questions (customizing by problem context)
# ###################################################

files <- 
  dir(path2fu_w_prev, ".txt")

files %>% 
  map(~load_puthtml_export(.x)) %>% 
  invisible()

# Bind with questions (by problem context)
item_files <- 
  dir(path2fu_qualtrics_items, ".txt")
question_files <- 
  dir(path2fu_qualtrics_questions, ".txt")

questions <- question_files %>% 
  map(~readChar(con = paste0(path2fu_qualtrics_questions,.x), nchars = file.size(paste0(path2fu_qualtrics_questions,.x)))) %>% 
  unlist

item_files %>% 
  map(~export_qualtrics_followup_items(.x)) %>% 
  invisible()


