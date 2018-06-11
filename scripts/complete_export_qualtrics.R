# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# Re-sources
source("scripts/html_qualtrics_codes.R")
source("functions/remove_placeholders.R")
source("functions/create_ED_blocks.R")

# Create pictorial prevalences --------------------------------------------

source("scripts/create_pictorial_prevalences.R")

# Create pictorial items (links to imgs) ----------------------------------

# read urls
pic_links <- 
  read_csv("materials/img_url.csv", 
           col_types = "cc", 
           col_names = c("cond", "url"))

# create items
walk2(.x = pic_links$cond, 
     .y = pic_links$url, 
     .f = function(x, y) {cat(gsub("LINK2IMG", y, html_codes$insert_img), 
              file = paste0("materials/qualtrics/output/plain_text/items/", x))})

# Create Embedded data Blocks ---------------------------------------------

# numbers
followUp_num <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% 
  filter(format == "fu") %>% select(format, prob, fu_risk)
ppv_num <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% 
  filter(format == "nfab") %>% select(prob, PPV)

# Conditions
conditions <- 
  read_csv("materials/conditions.csv", col_types = cols())

# Create and export txt files
create_ED_blocks()

# Create and export trial canvas ------------------------------------------

source("scripts/html_qualtrics_codes.R")

# ${e://Field/screening_intro_0}
# ${e://Field/screening_item_0}
# ${e://Field/ppv_question}

# RESPONSE TYPES
ED_screening_intro        <- "${e://Field/screening_intro_0}" %>% gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) 
ED_screening_item         <- "${e://Field/screening_item_0}" %>% gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) 
ED_screening_ppv_question <- "${e://Field/ppv_quest}" %>% gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) 

screening_item <- 
  paste(qualtrics_codes$advanced_format,
        qualtrics_codes$question_only_text,
        paste(ED_screening_intro, 
              ED_screening_item, 
              ED_screening_ppv_question, sep = "<br><br>"), sep = "\n")

resp_type_01 <- 
  paste(qualtrics_codes$question_singlechoice_horizontal,
        " ",
        qualtrics_codes$question_choices,
        paste('<span style="font-size: 16px;">Very few<br>(0-20%)</span>',
              '<span style="font-size: 16px;">Few<br>(21-40%)</span>',
              '<span style="font-size: 16px;">Half<br>(41-60%)</span>',
              '<span style="font-size: 16px;">Quite<br>(61-80%)</span>',
              '<span style="font-size: 16px;">Many<br>(81-100%)</span>', sep = "\n"), sep = "\n")

resp_type_02 <- 
  paste(qualtrics_codes$question_singlechoice_horizontal,
        " ",
        qualtrics_codes$question_choices,
        paste("___%"), sep = "\n")

resp_type_03 <- 
  paste(qualtrics_codes$question_singlechoice_horizontal,
        " ",
        qualtrics_codes$question_choices,
        paste("____ women receive a positive ${e://Field/sg_test_result_0} that correctly indicates the presence of ${e://Field/medical_condition_0},",
              "and ____ women receive a positive ${e://Field/sg_test_result_0} that incorrectly indicates the presence of ${e://Field/medical_condition_0}.",
              "Therefore, given that the ${e://Field/sg_test_result_0} indicates the signs of ${e://Field/medical_condition_0}, the probability that ${e://Field/sg_person_0} actually has ${e://Field/medical_condition_0} is ____ out of ____", sep = ""),
        sep = "\n")

resp_type_04 <- 
  paste(qualtrics_codes$question_singlechoice_horizontal,
        " ",
        qualtrics_codes$question_choices,
        paste("___ in every ___"), 
        sep = "\n")

screening_item_questions <- 
  paste(  screening_item,
          resp_type_01,
          resp_type_02,
          resp_type_03,
          resp_type_04,
          sep = "\n")

# Create trial customized
trials_no <- 2
screening_trials <- as.list(rep(screening_item_questions, trials_no))
# Customize to trials (2 trials)
for (a in seq(trials_no)) {
  # a <- 1
  screening_trials[[a]] <-
    screening_trials[[a]] %>% 
    gsub("([0-9])\\}", paste0("\\1", a, "}"), .) %>% 
    paste0("**trial_0", a, "**", .)
}

# Output dir
screening_output_dir <- 
  "materials/qualtrics/output/plain_text/screening_items/" %T>% 
  dir.create(., showWarnings = FALSE, recursive = TRUE) 

# Export each trial follow-up
screening_trials %>% 
  walk(~cat(gsub("\\*\\*.*\\*\\*", "", .x), sep = "", 
            file = paste0(screening_output_dir, "screening_", gsub("\\*\\*(.*)\\*\\*.*", "\\1", .x), ".txt"))
  )

# Create follow-up --------------------------------------------------------
source("scripts/followUp_create_export.R")

# Create and export complete trial blocks (PPV + Follow-up) ---------------

source("scripts/html_qualtrics_codes.R")

# screening item
screening_item_path <- 
  "materials/qualtrics/output/plain_text/screening_items/" 

screening_items <- 
  screening_item_path %>%
  dir(., pattern = ".txt") %>% 
  map(~readChar(paste0(screening_item_path, .x), file.size(paste0(screening_item_path, .x))))

# follow-up
followup_path <- 
  "materials/qualtrics/output/plain_text/followup/"

followup_items <- 
  followup_path %>%
  dir(., pattern = ".txt") %>% 
  map(~readChar(paste0(followup_path, .x), file.size(paste0(followup_path, .x))))

f <- function(x,y) {paste(x, qualtrics_codes$pagebreak, y, sep = "\n")}

screening_blocks <- 
  map2(.x = screening_items, .y = followup_items, .f = `f`)

dir.create("materials/qualtrics/output/plain_text/screening_blocks/", FALSE, TRUE)

f <- function(x,y) {cat(x, sep = "", 
                        file = paste0("materials/qualtrics/output/plain_text/screening_blocks/screening_block_0", y, ".txt"))}
walk2(.x = screening_blocks, .y = 1:2, .f = f)

