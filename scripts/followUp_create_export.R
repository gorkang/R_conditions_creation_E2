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
  ))

# 
unified_fu_questions <-
  unified_fu %>% 
  remove_placeholders(., item_followup = "followup") %>%                 # remove placeholders
  gsub("^\\n", "", .) %>%                                                # remove first linebreak
  gsub("\\n\\b", "", .) %>%                                              # remove last linebreak
  gsub("\\n", "<br>", .) %>%                                             # replace remaining linebreaks with html linebreaks
  gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) %>%  # add html code to follow-up text
  paste(qualtrics_codes$question_only_text,         # paste qualtrics tags with follow-up text and follow-up questions
        questioIDme("fu_I_0"),
        ., 
        paste(unlist(fu_questions), collapse = "\n"), sep = "\n")

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

# PREVALENCES #################################
# Create pictorial prevalences
source("scripts/create_pictorial_prevalences.R")
###############################################




# To fill ED data fields
fillers <- read_csv("materials/fillers.csv", col_types = "cccc") %>% 
  mutate(ca_pr = paste(ca, pr, sep = "/"))

fu_risk <- readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% 
  filter(format == "fu") %>% pull(fu_risk) %>% paste(., collapse = "/")

"materials/qualtrics/output/plain_text/followup/fu_unified.txt" %>% 
  readChar(., file.size(.)) %>% gsub("\\[{2}ID\\:([a-zA-Z_0-9]*)\\]{2}", "**\\1**", .) %>% 
  
  # Remove and replace
  gsub("<br>" ,"\n", .) %>%          # replace html linebreak with generic linebreak (R linebreak?)
  gsub("</li><li>" ,"\n ", .) %>%    # replace between list elements with linebreaks
  gsub("<li>" ,"\n", .) %>%          # replace list beginning with linebreaks
  gsub("</li>" ,"\n\n", .) %>%       # replace list end with slinebreaks
  gsub('<span style="font-size\\:[0-9]{2}px;">', " ", .) %>% # remove html font size formating
  gsub('</span>', "", .) %>% # remove html format end
  gsub("\\[{2}Choices\\]{2}\\n", "", .) %>% # remove choices placeholder
  gsub("\\[{2}PageBreak\\]{2}\\n", "", .) %>% # remove pagebreak placeholder 
  gsub("\\[{2}Question.*?\\]{2}\\n", "", .) %>% # remove question placeholder
  gsub("DELETE_THIS", "", .) %>% # remove DELETE_THIS placeholder
  
  # Fill ED data fields
  gsub("\\$\\{e\\://Field/fu_risk_num_0\\}", fu_risk, .) %>% 
  gsub("\\$\\{e\\://Field/medical_condition_0\\}",    fillers$ca_pr[fillers$field_name == "medical_condition"], .) %>% 
  gsub("\\$\\{e\\://Field/medical_consequence_0\\}",  fillers$ca_pr[fillers$field_name == "medical_consequence"], .) %>% 
  gsub("\\$\\{e\\://Field/positive_test_result_0\\}", fillers$ca_pr[fillers$field_name == "positive_test_result"], .) %>%
  gsub("\\$\\{e\\://Field/doctor_offers_0\\}",        fillers$ca_pr[fillers$field_name == "doctor_offers"], .) %>% 
  gsub("\\$\\{e\\://Field/fluid_test_0\\}",           fillers$ca_pr[fillers$field_name == "fluid_test"], .) %>% 
  gsub("\\$\\{e\\://Field/test_name_0\\}",            fillers$ca_pr[fillers$field_name == "test_name"], .) %>% 
  
  # Double linebreaks because bookdown displaying is weird (one linebreak doesn't work, two linebreaks actually creates two linebreaks)
  gsub("\\n", "\n\n", .) %>% 
  cat(., "  \n  \n ______________________  \n")

# Print prevalences
"materials/qualtrics/output/plain_text/prevalences/" %>% dir(., ".txt", full.names = TRUE) %>% 
  map_chr(~readChar(.x, file.size(.x))) %>% 
  gsub("([a-z]\\*{2})", "\\1: ", .) %>% cat("**PREVALENCES**:  \n", ., sep = "  \n")

