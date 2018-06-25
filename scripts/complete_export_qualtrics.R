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
           col_names = c("cond", "url")) %>%
  mutate(url = gsub("\\:", "&#58;", url))


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

# INTRO TO ITEM
ED_screening_intro        <- 
  "${e://Field/screening_intro_0}" %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) 
# ITEM
ED_screening_item         <- 
  "${e://Field/screening_item_0}" %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) 
# PPV QUESTION
ED_screening_ppv_question <-
  "materials/Question/Calculation/input/unified_question.txt" %>% 
  readChar(., file.size(.)) %>% remove_placeholders(.) %>% 
  gsub("\\n", "", .) %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size) 

# Assemble item (ppv question is a question by itself to be able to hide it on pfab & sg condition)
screening_item <-
  paste(qualtrics_codes$advanced_format,
        qualtrics_codes$question_only_text,
        paste(ED_screening_intro, 
              ED_screening_item, sep = "<br><br>"),
        qualtrics_codes$question_only_text,
        ED_screening_ppv_question, sep = "\n")

# Response types ####
# gs: text entry
# sg: 4 text entry
# ss: 2 text entry

# Global intuitive (single choice)
resp_type_01 <- 
  paste(qualtrics_codes$question_singlechoice_horizontal,
        " ",
        qualtrics_codes$question_choices,
        paste('<span style="font-size: 16px;">Very few<br>(0-20%)</span>',
              '<span style="font-size: 16px;">Few<br>(21-40%)</span>',
              '<span style="font-size: 16px;">Half<br>(41-60%)</span>',
              '<span style="font-size: 16px;">Quite<br>(61-80%)</span>',
              '<span style="font-size: 16px;">Many<br>(81-100%)</span>', sep = "\n"), sep = "\n")
# Sistemic global (__%)
resp_type_02 <-
  paste(qualtrics_codes$question_textentry,
        " ",
        sep = "\n")
# sequential guided (__ will have out of __. __ will ...)
resp_type_03 <- 
  paste(qualtrics_codes$question_textentry,
        " ",
        qualtrics_codes$question_textentry,
        " ",
        qualtrics_codes$question_textentry,
        " ",
        qualtrics_codes$question_textentry,
        " ",
        sep = "\n")
# sequential simple (__ out of __)
resp_type_04 <- 
  paste(qualtrics_codes$question_textentry,
        " ",
        qualtrics_codes$question_textentry,
        " ",
        sep = "\n")

# Willingness to undergo screening test (according to issue #61 on github)

will_screening <-
  paste(qualtrics_codes$question_only_text,
        gsub("QUESTION_TEXT_TO_FORMAT", 
             "Imagine a woman you care about is offered to participate a in routine screening test to detect ${e://Field/medical_condition_0} as the one you saw before.", 
             html_codes$question_font_size), sep = "\n")

will_screening_01 <- 
  paste(qualtrics_codes$question_singlechoice_vertical,
        gsub("QUESTION_TEXT_TO_FORMAT", 
             "Should she take the screening test?", 
             html_codes$question_font_size),
        qualtrics_codes$question_choices,
        "Yes" %>% gsub("CHOICES_TEXT_TO_FORMAT", ., html_codes$choices_font_size),
        "No" %>% gsub("CHOICES_TEXT_TO_FORMAT", ., html_codes$choices_font_size), sep = "\n")

will_screening_02 <-
  paste(qualtrics_codes$question_only_text,
        gsub("QUESTION_TEXT_TO_FORMAT", 
             "How strongly would you recommend her to take the screening test (0-100%)", 
             html_codes$question_font_size), sep = "\n")

# Assemble item with response types
screening_item_questions <-
  paste(  screening_item,
          resp_type_01,
          resp_type_02,
          resp_type_03,
          resp_type_04,
          qualtrics_codes$pagebreak,
          will_screening,
          will_screening_01,
          will_screening_02,
          sep = "\n")

# Create follow-up --------------------------------------------------------
source("scripts/followUp_create_export.R")

# Create and export complete trial blocks (PPV + Follow-up) ---------------

# follow-up
followup_path <- 
  "materials/qualtrics/output/plain_text/followup/"

# read follow-up item
followup_items <- 
  followup_path %>%
  dir(., pattern = ".txt") %>% 
  map(~readChar(paste0(followup_path, .x), file.size(paste0(followup_path, .x))))

# Append screening item with follow-up
complete_item <- 
  paste(screening_item_questions, 
        qualtrics_codes$pagebreak,
        followup_items, sep = "\n")
complete_item %>% cat
# Output dir
screening_output_dir <- 
  "materials/qualtrics/output/plain_text/screening_items/" %T>% 
  dir.create(., showWarnings = FALSE, recursive = TRUE) 

# Customize item to trial
# func to customize
f <- function(x) {
  gsub("([0-9])\\}", paste0("\\1", x, "}"), complete_item) %>% 
    paste0("**trial_0", x, "**", .)
}

# dir to output screening blocks 
screening_block_output_dir <- 
  "materials/qualtrics/output/plain_text/screening_blocks/partial/" %T>% 
  dir.create(., FALSE, TRUE)

# customize items
map(1:2, ~f(.x)) %>% 
  walk(~cat(gsub("\\*\\*.*\\*\\*", "", .x), sep = "",
            file = paste0(screening_block_output_dir, "screening_block_", gsub("\\*\\*(.*)\\*\\*.*", "\\1", .x), ".txt")))


# Join blocks -------------------------------------------------------------

complete_screening_block_output_dir <- 
  "materials/qualtrics/output/plain_text/screening_blocks/complete/" %T>% 
  dir.create(., FALSE, TRUE)

screening_block_output_dir %>% 
  dir(., ".txt") %>% 
  map_chr(~readChar(paste0(screening_block_output_dir, .x), file.size(paste0(screening_block_output_dir, .x)))) %>% 
  paste(., collapse = "\n\n") %>% cat()


# JS codes to give format to response type questions ----------------------
source("scripts/create_js.R")
