# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# Re-sources
source("scripts/html_qualtrics_codes.R")
source("functions/remove_placeholders.R")
source("functions/create_ED_blocks.R")
source("functions/questionIDme.R")

# Create experiment design block -------------------------------------

# Read text
exp_design <- 
  "materials/experiment_design/input/experiment_design.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\n$", "", .)
# Add html font size tag 
exp_design <- 
  gsub("QUESTION_TEXT_TO_FORMAT", exp_design, html_codes$question_font_size)

# output dir
output_dir <- 
  "materials/qualtrics/output/plain_text/exp_design" %T>% 
  dir.create(., FALSE, TRUE)

# add qualtrics tags
paste(qualtrics_codes$advanced_format,
      gsub("block_name", "experiment_design", qualtrics_codes$block_start), 
      qualtrics_codes$question_only_text,
      gsub("question_id", "exp_design", qualtrics_codes$question_id), 
      exp_design, sep = "\n") %>% 
  # export to text file
  cat(., file = file.path(output_dir, "experiment_design.txt"))


# Create pictorial items (links to imgs) ----------------------------------

# read urls
pic_links <-
  read_csv("materials/img_url.csv", col_types = "cc") %>%
  mutate(url = gsub("\\:", "&#58;", url))

# create items
walk2(.x = pic_links$condition, 
      .y = pic_links$url, 
      .f = function(x, y) {cat(gsub("LINK2IMG", y, html_codes$insert_img), 
                               file = paste0("materials/qualtrics/output/plain_text/items/", x, ".txt"))})

# Create Embedded data Blocks ---------------------------------------------

# numbers
followUp_num <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% 
  filter(format == "fu") %>% select(format, prob, fu_risk)
ppv_num <- 
  readxl::read_xls("materials/Numbers/numbers_bayes.xls") %>% 
  filter(format == "nfab") %>% select(prob, PPV, age, prev_02)

# Conditions
conditions <- 
  read_csv("materials/conditions.csv", col_types = cols())

# Create and export txt files
create_ED_blocks()

# Create and export trial canvas ------------------------------------------

# Medical condition block title
med_cond_block_title <-
  "Medical condition BLOCK_NUMBER_0/2" %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", . , html_codes$title_font_size) %>% 
  gsub("STRONGME", ., html_codes$bold)

med_cond_block_title <- 
  paste(qualtrics_codes$question_only_text,
        questioIDme("ppv_title_0"),
        med_cond_block_title,
        qualtrics_codes$pagebreak, sep = "\n")

# Instructions
gen_instructions <- 
  "materials/ppv_instructions/input/ppv_instructions.txt" %>% 
  readChar(., file.size(.)) %>% 
  gsub("\n$", "", .) %>% 
  gsub("QUESTION_TEXT_TO_FORMAT", ., html_codes$question_font_size)

gen_instructions <- 
  gen_instructions %>% 
  paste(qualtrics_codes$question_only_text, 
        gsub("question_id", "gen_ins_0", qualtrics_codes$question_id), 
        ., sep = "\n")

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
  readChar(., file.size(.)) %>%
  gsub("\\n", "", .) %>% 
  str_split(., "___QSEP___") %>% 
  unlist() %>% 
  str_replace(string = html_codes$question_font_size, pattern = "QUESTION_TEXT_TO_FORMAT", replacement = .) %>% 
  paste(qualtrics_codes$question_only_text, qualtrics_codes$question_id, ., sep = "\n") %>%
  str_replace_all(string = ., 
                  pattern = "question_id", 
                  replacement = paste0("ppv_q_", sprintf("%02d", 1:2), "_0")) %>% 
  paste(., collapse = "\n")

# Assemble item (ppv question is a question by itself to be able to hide it on pfab & sg condition)
screening_item <-
  paste(qualtrics_codes$question_only_text,
        questioIDme("ppv_ins_0"),
        paste(ED_screening_intro, 
              ED_screening_item, sep = "<br><br>"),
        ED_screening_ppv_question, sep = "\n")

# Response types ####
# gs: text entry
# sg: 4 text entry
# ss: 2 text entry

# Global intuitive (single choice)
resp_type_01 <- 
  paste(qualtrics_codes$question_singlechoice_horizontal,
        questioIDme("ppv_gi01_0"),
        " ",
        qualtrics_codes$question_choices,
        paste('<span style="font-size: 16px;">Very few<br>(0-20%)</span>',
              '<span style="font-size: 16px;">Few<br>(21-40%)</span>',
              '<span style="font-size: 16px;">Half<br>(41-60%)</span>',
              '<span style="font-size: 16px;">Quite<br>(61-80%)</span>',
              '<span style="font-size: 16px;">Many<br>(81-100%)</span>', sep = "\n"), sep = "\n")
# Global sistematic (__%)
resp_type_02 <-
  paste(qualtrics_codes$question_textentry,
        questioIDme("ppv_gs01_0"),
        " ",
        sep = "\n")
# sequential guided (__ will have out of __. __ will ...)
resp_type_03 <- 
  paste(qualtrics_codes$question_textentry,
        questioIDme("ppv_sg01_0"),
        " ",
        qualtrics_codes$question_textentry,
        questioIDme("ppv_sg02_0"),
        " ",
        qualtrics_codes$question_textentry,
        questioIDme("ppv_sg03_0"),
        " ",
        qualtrics_codes$question_textentry,
        questioIDme("ppv_sg04_0"),
        " ",
        sep = "\n")
# sequential simple (__ out of __)
resp_type_04 <- 
  paste(qualtrics_codes$question_textentry,
        questioIDme("ppv_ss01_0"),
        " ",
        qualtrics_codes$question_textentry,
        questioIDme("ppv_ss02_0"),
        " ",
        sep = "\n")

# Willingness to undergo screening test (according to issue #61 on github)
will_screening <- 
  "materials/Question/willing_screen/willing_screen.txt" %>% 
  readChar(., file.size(.))

# Comprehension
source("scripts/comprehension.R")

comprehension <- 
  "materials/qualtrics/output/plain_text/comprehension/comprehension.txt" %>% 
  readChar(., file.size(.))

# Assemble item with response types
screening_item_questions <-
  paste(gsub("block_name", "ppv_screening_0", qualtrics_codes$block_start),
        med_cond_block_title,
        gen_instructions,
        qualtrics_codes$pagebreak,
        screening_item,
        resp_type_01,
        resp_type_02,
        resp_type_03,
        resp_type_04,
        gsub("block_name", "willing_to_screen_0", qualtrics_codes$block_start),
        will_screening,
        gsub("block_name", "comprehension_0", qualtrics_codes$block_start),
        comprehension,
        sep = "\n")

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
        gsub("block_name", "follow_up_0", qualtrics_codes$block_start),
        followup_items, sep = "\n")


# Add severity/emotion scales ---------------------------------------------

# Read questions and add font size html format
severity_emo_scale <-
  "materials/Question/severity_emotion/severity_emotional_reaction.txt" %>% 
  readChar(., file.size(.)) %>% gsub("Q_FONT_SIZE", 22, .) %>% 
  gsub("C_FONT_SIZE", 16, .) %>% 
  gsub("\n$", "", .)

# Put question ids
severity_emo_scale <-
  severity_emo_scale %>% 
  str_split(., "\n__QSEP__\n") %>% unlist() %>% 
  str_replace(string = ., 
              pattern = "replaceID", 
              replacement = c(pattern1 = paste0("sevEmo_", sprintf("%02d", 1:5), "_0"))) %>% 
  paste(., collapse = "\n")

# Add extra question for trisomy 21 (display logic has to be set on qualtrics to display this question only when the context is trisomy)
severity_emo_scale_extra <-
  "materials/Question/severity_emotion/extra_trisomy.txt" %>% 
  readChar(., file.size(.)) %>% gsub("Q_FONT_SIZE", 22, .) %>% 
  gsub("C_FONT_SIZE", 16, .) %>% 
  gsub("\n$", "", .) %>% gsub("replaceID", "sevEmo_06_0", .)

# Bind screening with severity emotion scale
complete_item <-
  paste(complete_item, 
        gsub("block_name", "severity_emotion_scale_0", qualtrics_codes$block_start),
        severity_emo_scale,
        severity_emo_scale_extra, # extra question (only for trisomy)
        sep = "\n")

# Export ------------------------------------------------------------------

# Output dir
screening_output_dir <- 
  "materials/qualtrics/output/plain_text/screening_template/" %T>% 
  dir.create(., showWarnings = FALSE, recursive = TRUE) 

# Export screening item without trial
complete_item %>% cat(., file = file.path(screening_output_dir, "item_template.txt"))

# Customize item to trial
# func to customize
f <- function(x) {
  gsub("(_[0-9])\\b(\\}?\\]?)", paste0("\\1", x, "\\2"), complete_item) %>%
    gsub("BLOCK_NUMBER_0", "", .) %>%
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
  paste(qualtrics_codes$advanced_format, ., sep = "\n") %>% 
  cat(., file = file.path(complete_screening_block_output_dir, "screenings_blocks.txt"))

# JS codes to give format to response type questions ----------------------
source("scripts/create_js.R")
