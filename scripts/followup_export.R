# TODO: consider what to do with sliders text (if sliders has text before, do a single choice vertical. if not, a simple text only question)
# TODO: what to do with the last follow-up question. has to had a logic display regarding the first follow-up question.
# TODO: last followup question has to be splitted in two. IF any question suppose the use of a display logic it has to be separated in a question for each condition.
# TODO: blank space at the beginning of exported text blocks? 
# TODO: how to indicate the questions that require manual setting within qualtrics (e.g. display logic questions)

# There are 16 unique(ish) prevalences (2 contexts x 4 formats x 2 ppv prob)
# There are 2 follow-up risk (1%, 10%)
# Therefore, there are 32 possible follow-up items (e.g. ca_nfab_low_high; ppvLow_riskHigh)


# Functions ----------------------
# All the following functions are exclusively for dealing with follow-up qualtrics-html building and export

source("scripts/html_qualtrics_codes.R")
source("functions/extract_between_placeholders.R")
source("functions/choice_builder.R")
source("functions/prev2followup.R")
source("functions/followup_question_builder.R")
source("functions/load_puthtml_export.R")
source("functions/export_qualtrics_followup_items.R")

# ALL PATHS ----------------------

path2fu_raw_questions              <- "materials/Question/Follow_up/input/questions_raw/"
path2fu_w_prev                     <- "materials/Question/Follow_up/output/item_w_prevalence/"
path2fu_qualtrics_items            <- "materials/qualtrics/input/followUp/items/"
path2fu_qualtrics_questions        <- "materials/qualtrics/input/followUp/questions/"
path2fu_qualtrics_complete_items   <- "materials/qualtrics/output/followUp/"


# Follow-up questions building ----
# iterates through files in file_path, identifies how choices the question has, build choices and question and export them (default) or paste them

dir(path2fu_raw_questions, ".txt") %>% 
  map(~followup_question_builder(file_path = path2fu_raw_questions, file_name = .x, outputdir = path2fu_qualtrics_questions)) %>% 
  invisible()

# Follow-up item building with unique prevalences --------
# Get unique response types to get all unique prevalences. These are used to create unique follow-up items.

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

# Bind follow-up items with questions (customizing by problem context) ------------------

# put html tags around follow-up items (already with prevalences)
# path to follow-up items with prevalence 
files <- 
  dir(path2fu_w_prev, ".txt")
# paste html tags
files %>% 
  map(~load_puthtml_export(.x)) %>% 
  invisible()

# Bind items with questions (by problem context)
# follow-up items (already with html tags and prevalences) files
item_files <- 
  dir(path2fu_qualtrics_items, ".txt")
# follow-up question files
question_files <- 
  dir(path2fu_qualtrics_questions, ".txt")
# vector with questions to paste to items
questions <- question_files %>% 
  map(~readChar(con = paste0(path2fu_qualtrics_questions,.x), nchars = file.size(paste0(path2fu_qualtrics_questions,.x)))) %>% 
  unlist

# paste and export all together 
item_files %>% 
  map(~export_qualtrics_followup_items(.x)) %>% 
  invisible()

# Follow-up questions building -------------------------------------

allblocks_dir <- "materials/qualtrics/output/followUp/all_blocks/all_blocks.txt"
dir.create(allblocks_dir, showWarnings = FALSE, recursive = TRUE)
# get all follow-up complete items to a vector
followup_complete_items <- 
  dir(path2fu_qualtrics_complete_items, ".txt") %>% 
  map(~readChar(paste0(path2fu_qualtrics_complete_items, .x), nchars = file.size(paste0(path2fu_qualtrics_complete_items, .x)))) %>% 
  unlist()
# get follow-up complete items names
followup_block_names <- 
  gsub("\\.txt", "", dir(path2fu_qualtrics_complete_items, ".txt")) %>% 
  map(~gsub("block_name", .x, qualtrics_codes$block_start)) %>% unlist
# create quacltrics blocks tags names
followup_blocks <- 
  paste(followup_block_names, "\n", followup_complete_items, sep = "")
# collapse all items in one text file separating by block
cat(paste(followup_blocks, collapse = "", sep = ""), sep = "", file = paste0(allblocks_dir, "all_blocks.txt"))

