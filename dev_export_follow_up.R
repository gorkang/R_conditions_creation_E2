# TODO: missing linebrekas within items?
# TODO: consider what to do with sliders text (if sliders has text before, do a single choice vertical. if not, a simple text only question)
# TODO: what to do with the last follow-up question. has to had a logic display regarding the first follow-up question.

# There are 16 unique(ish) prevalences (2 contexts x 4 formats x 2 ppv prob)
# There are 2 follow-up risk (1%, 10%)
# Therefore, there are 32 possible follow-up items (e.g. ca_nfab_low_high; ppvLow_riskHigh)

source("scripts/html_qualtrics_codes.R")
source("functions/extract_between_placeholders.R")
source("functions/choice_builder.R")

# ALL PATHS ****************************
path2fu_raw_questions              <- "materials/Question/Follow_up/input/questions_raw/"
path2fu_w_prev                     <- "materials/Question/Follow_up/output/item_w_prevalence/"
path2fu_qualtrics_items            <- "materials/qualtrics/input/follow-up/items/"
path2fu_qualtrics_questions        <- "materials/qualtrics/input/follow-up/questions/"
path2fu_qualtrics_complete_items   <- "materials/qualtrics/output/followUp/"

# **************************************

# ##################################
# Follow-up questions building
# ##################################

# ##################################
# Follow-up question 1
# ##################################

response_path <- 
  paste0(path2fu_raw_questions, "followup_question_01.txt")
response_text <- 
  readChar(response_path, file.info(response_path)$size)

current_choices <- 
  choice_builder(response_string = response_text) %>% 
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
  , file = paste0(path2fu_qualtrics_questions, "followup_question_01.txt")
)

# ##################################
# Follow-up question 2
# ##################################

response_path <- 
  paste0(path2fu_raw_questions, "followup_question_02.txt")
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
  , file = paste0(path2fu_qualtrics_questions, "followup_question_02.txt")
)

# ##################################
# Follow-up question 3
# ##################################

response_path <- 
  paste0(path2fu_raw_questions, "followup_question_03.txt")
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
  , file = paste0(path2fu_qualtrics_questions, "followup_question_03.txt")
)

# ##################################
# Follow-up question 4
# ##################################

response_path <- 
  paste0(path2fu_raw_questions, "followup_question_04.txt")
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
  , file = paste0(path2fu_qualtrics_questions, "followup_question_04.txt")
)

# ##################################
# Follow-up question 5
# ##################################

response_path <- 
  paste0(path2fu_raw_questions, "followup_question_05.txt")
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
  , file = paste0(path2fu_qualtrics_questions, "followup_question_05.txt")
)

rm("response_path", "response_text", "current_choices")

# #############################################################3
# #############################################################3
# #############################################################3
# #############################################################3

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

# create follow-up item with every unique prevalence
unique_prevalences %>% 
  map(~prev2followUp(prevalence_string = .x, 
                     follow_up_dir = "materials/Question/Follow_up/output/item_raw/", 
                     outputdir = "materials/Question/Follow_up/output/item_w_prevalence/", rmv_placeholders = TRUE) ) %>% 
  invisible()



# #######################
files <- 
  dir(path2fu_w_prev, ".txt")

# custom func to load files, wrapped them with html text code, and export them.
load_puthtml_export <- 
  function(x) {
    # x <- files[1]
    # load item
    item_text <- 
      readChar(con = paste0(path2fu_w_prev,x), nchars = file.info(paste0(path2fu_w_prev,x))$size)
    # put html label around item
    cat(gsub("QUESTION_TEXT_TO_FORMAT", item_text, html_codes$question_font_size), 
        file = paste0(path2fu_qualtrics_items, x))
  }

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

export_qualtrics_followup_items <- function(x) {
  
  # x <- item_files[1]
  x_context <- gsub("-*(ca|pr).*", "\\1", x)
  x_item <- readChar(con = paste0(path2fu_qualtrics_items,x), nchars = file.info(paste0(path2fu_qualtrics_items,x))$size)
  
  dir.create(path2fu_qualtrics_complete_items, showWarnings = FALSE, recursive = TRUE)
  
  if (x_context == "ca") {
    
    cat(qualtrics_codes$advanced_format, "\n",
        qualtrics_codes$question_only_text, "\n",
        x_item, "\n",
        gsub("risk_percentage", 
             gsub(".*([0-9]{2}%).*", "\\1", x_item), 
             gsub("medical_condition", "breast cancer", paste(questions, collapse = "\n"))),
        sep = ""
        , file = paste0(path2fu_qualtrics_complete_items, x)
    )
  } else if (x_context == "pr") {
    
    cat(qualtrics_codes$advanced_format, "\n",
        qualtrics_codes$question_only_text, "\n",
        x_item, "\n",
        gsub("risk_percentage", 
             gsub(".*([0-9]{2}%).*", "\\1", x_item), 
             gsub("medical_condition", "Trisomy 21", paste(questions, collapse = "\n"))),
        sep = ""
        , file = paste0(path2fu_qualtrics_complete_items, x)
    )
  }
  
}

item_files %>% 
  map(~export_qualtrics_followup_items(.x)) %>% 
  invisible()


