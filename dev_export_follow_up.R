

# There are 16 unique(ish) prevalences (2 contexts x 4 formats x 2 ppv prob)
# There are 2 follow-up risk (1%, 10%)
# Therefore, there are 32 possible follow-up items (e.g. ca_nfab_low_high; ppvLow_riskHigh)

# TODO: add qualtric/html format to export

source("scripts/html_qualtrics_codes.R")
source("functions/extract_between_placeholders.R")

# load response.
response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_03.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)




source("functions/choice_builder.R")

# ##################################
# Continue dev of choice builder
# ##################################







# Follow-up Questions building
# Follow-up Question 1
response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_01.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

choices_number <- 
  (sum(str_detect(pattern = paste0(ordinal_numbers, "_choice"), string = response_text)) + 1)

choices <- 
  c("first", ordinal_numbers[seq(choices_number-1)])

# actual choice building
# choices_x <- 
  xxx <- 
    choices %>% 
  map(~choice_builder(choices_ordinal = .x, response_string = response_text)) %>% 
    invisible() 
  




cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  # QUESTION TYPE ********************
  qualtrics_codes$question_singlechoice_vertical, "\n",
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choiches_start", response_text), 
       html_codes$question_font_size), "\n",
  # CHOICES FORMAT ********************
  qualtrics_codes$question_choices, "\n",
  # CHOICES ********************
  choices %>% 
    map(~choice_builder(choices_ordinal = .x, response_string = response_text)) %>% 
    invisible() %>% unlist,
  
  # gsub("CHOICES_TEXT_TO_FORMAT", 
  #      extract_between_placeholders("choiches_start", "second_choice", response_text), 
  #      html_codes$choices_font_size), "\n",
  # 
  # gsub("CHOICES_TEXT_TO_FORMAT", 
  #      extract_between_placeholders("second_choice", "choices_end", response_text), 
  #      html_codes$choices_font_size), "\n",
  
  sep = ""
  # FILE TO EXPORT
  # file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_01.txt"
  )

# Follow-up Question 2
response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_02.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  # QUESTION TYPE ********************
  qualtrics_codes$question_text, "\n",
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choiches_start", response_text), 
       html_codes$question_font_size), "\n",
  # # CHOICES FORMAT ********************
  # qualtrics_codes$question_choices, "\n",
  # # CHOICES ********************
  # gsub("CHOICES_TEXT_TO_FORMAT", 
  #      extract_between_placeholders("choiches_start", "choices_end", response_text), 
  #      html_codes$choices_font_size), "\n",
  
  sep = "",
  # FILE TO EXPORT
  file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_02.txt")

# Follow-up Question 3
response_path <- 
  "materials/Question/Follow_up/input/questions_raw/followup_question_03.txt"
response_text <- 
  readChar(response_path, file.info(response_path)$size)

cat(
  # # ADVANCED FORMAT ********************
  # qualtrics_codes$advanced_format, "\n",
  # QUESTION TYPE ********************
  qualtrics_codes$question_singlechoice_vertical, "\n",
  # QUESTION ********************
  gsub("QUESTION_TEXT_TO_FORMAT", 
       extract_between_placeholders("question_start", "choiches_start", response_text), 
       html_codes$question_font_size), "\n",
  # CHOICES FORMAT ********************
  qualtrics_codes$question_choices, "\n",
  # CHOICES ********************
  gsub("CHOICES_TEXT_TO_FORMAT",
       extract_between_placeholders("choiches_start", "choices_end", response_text),
       html_codes$choices_font_size), "\n",
  
  sep = "",
  # FILE TO EXPORT
  file = "materials/Question/Follow_up/input/questions_qualtrics/followup_question_02.txt")



# ######################
# ######################
# ######################
# ######################



# This has to be put on the choices part within each question building
# ordinal_numbers <- 
#   c("second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth")

choices_number <- 
  (sum(str_detect(pattern = paste0(ordinal_numbers, "_choice"), string = response_text)) + 1)

choices <- 
  c("first", ordinal_numbers[seq(choices_number-1)])

# actual choice building
choices %>% 
  map(~choice_builder(choices_ordinal = .x, response_string = response_text)) %>% 
  invisible()

# ######################
# ######################
# ######################
# ####################

item_test <- problems_numbered_ordered_responses[[10]]

item_test %>% cat

uniqchars <- 
  function(x) unique(strsplit(x, "")[[1]]) 

response_type_regex <-
  dir("materials/Response_type/", pattern = ".txt") %>% 
  gsub("\\.txt", "", .) %>% paste(., collapse = "") %>% 
  uniqchars() %>% paste(., collapse = "")

# This snippet get only names
# unique_prevalences_names <-
#   problems_numbered_ordered_responses[seq(1, length(problems_numbered_ordered_responses), 4)] %>% 
#   map(~gsub(paste0("\\*\\*(.*)_[", response_type_regex, "]{2}\\*\\*(.*)"), "\\1\\2", .x)) %>% unlist

# names and prevalences
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


prev2followUp(prevalence_string = unique_prevalences[[2]], follow_up_dir = "materials/Question/Follow_up/output/", 
              outputdir = "materials/qualtrics/output/followUp/", rmv_placeholders = TRUE)
