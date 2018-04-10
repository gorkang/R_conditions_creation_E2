

# There are 16 unique(ish) prevalences (2 contexts x 4 formats x 2 ppv prob)
# There are 2 follow-up risk (1%, 10%)
# Therefore, there are 32 possible follow-up items (e.g. ca_nfab_low_high; ppvLow_riskHigh)

# TODO: add qualtric/html format to export

source("scripts/html_qualtrics_codes.R")
source("functions/extract_between_placeholders.R")
source("functions/choice_builder.R")

# ##################################
# Continue dev of choice builder
# ##################################

# ##################################
# Follow-up question 1
# ##################################

response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_01.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

current_choices <- choice_builder(response_string = response_text) %>% 
  unlist

cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  
  # QUESTION TYPE ********************
  gsub("(\\[\\[.*\\]\\]).*", "\\1", response_text), "\n",
  
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choices_start", response_text), 
       html_codes$question_font_size), "\n",
  
  # CHOICES FORMAT ********************
  qualtrics_codes$question_choices, "\n",
  # CHOICES ***************************
  paste(current_choices, collapse = "\n"), "\n",
  
  # SEP *******************************
  sep = ""
  # FILE TO EXPORT
  , file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_01.txt"
)

# ##################################
# Follow-up question 2
# ##################################

response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_02.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

current_choices <- choice_builder(response_string = response_text) %>% 
  unlist

cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  
  # QUESTION TYPE ********************
  gsub("(\\[\\[.*\\]\\]).*", "\\1", response_text), "\n",
  
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choices_start", response_text), 
       html_codes$question_font_size), "\n",
  
  # CHOICES FORMAT ********************
  qualtrics_codes$question_choices, "\n",
  # CHOICES ***************************
  paste(current_choices, collapse = "\n"), "\n",
  
  # SEP *******************************
  sep = ""
  # FILE TO EXPORT
  , file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_02.txt"
)

# ##################################
# Follow-up question 3
# ##################################

response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_03.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

current_choices <- choice_builder(response_string = response_text) %>% 
  unlist

cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  
  # QUESTION TYPE ********************
  gsub("(\\[\\[.*\\]\\]).*", "\\1", response_text), "\n",
  
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choices_start", response_text), 
       html_codes$question_font_size), "\n",
  
  # CHOICES FORMAT ********************
  qualtrics_codes$question_choices, "\n",
  # CHOICES ***************************
  paste(current_choices, collapse = "\n"), "\n",
  
  # SEP *******************************
  sep = ""
  # FILE TO EXPORT
  , file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_03.txt"
)

# ##################################
# Follow-up question 4
# ##################################

response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_04.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

current_choices <- choice_builder(response_string = response_text) %>% 
  unlist

cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  
  # QUESTION TYPE ********************
  gsub("(\\[\\[.*\\]\\]).*", "\\1", response_text), "\n",
  
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choices_start", response_text), 
       html_codes$question_font_size), "\n",
  
  # CHOICES FORMAT ********************
  qualtrics_codes$question_choices, "\n",
  # CHOICES ***************************
  paste(current_choices, collapse = "\n"), "\n",
  
  # SEP *******************************
  sep = ""
  # FILE TO EXPORT
  , file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_04.txt"
)

# ##################################
# Follow-up question 5
# ##################################

response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_05.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

current_choices <- choice_builder(response_string = response_text) %>% 
  unlist

cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  
  # QUESTION TYPE ********************
  gsub("(\\[\\[.*\\]\\]).*", "\\1", response_text), "\n",
  
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choices_start", response_text), 
       html_codes$question_font_size), "\n",
  
  # CHOICES FORMAT ********************
  qualtrics_codes$question_choices, "\n",
  # CHOICES ***************************
  paste(current_choices, collapse = "\n"), "\n",
  
  # SEP *******************************
  sep = ""
  # FILE TO EXPORT
  , file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_05.txt"
)

rm("response_path", "response_text", "current_choices")

# #############################################################3
# #############################################################3
# #############################################################3
# #############################################################3

# TODO: 
# 0. add followup items with qualtrics and html codes.
# 1. paste questions (without placeholders) to followup items to be displayed.
# 2. paste questions with codes with followup with codes.

# item_test <- 
#   problems_numbered_ordered_responses[[10]]

# item_test %>% 
#   cat

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

# prev2followUp(unique_prevalences[[2]], "materials/Question/Follow_up/output/")
source("functions/prev2followup.R")

unique_prevalences %>% 
  map(~prev2followUp(prevalence_string = .x, 
                     follow_up_dir = "materials/Question/Follow_up/output/", 
                     outputdir = "materials/qualtrics/output/followUp/", rmv_placeholders = TRUE) ) %>% 
  invisible()

