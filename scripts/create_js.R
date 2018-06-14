# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse)

# create dir to output codes
dir.create("materials/qualtrics/output/plain_text/js_codes", FALSE, TRUE)

# Get current question ID. for every code.  
var_qid <- "var qid_01_str = this.questionId;" 

# GI ----------------------------------------------------------------------
# COMMENTS
gi                     <- list(reptype_name = "/* GI RESPONSE TYPE */")
gi$general_description <- "/* Only to remove separator */"
gi$indication          <- "/* This code has to be pasted on addOnReady section */"
# CURRENT ID
gi$qid                 <- var_qid
gi$qid_num             <- "\n/* keep ID number */\nvar qid_01_num = Number(qid_01_str.replace(/^\\D+/g, ''));" # extra "\" before "\D" because "\" is a metacharacter.
# REMOVE SEPARATORS
gi$rmv_sep             <- "\n/* remove separator (if any) */\ndocument.getElementById('QID' + qid_01_num + 'Separator').style.height='0px';"

# export to txt file
gi %>% 
  paste(., collapse = "\n") %>% 
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/gi_js.txt")

# GS response type --------------------------------------------------------
# COMMENTS
gs                     <- list(reptype_name = "/* GS RESPONSE TYPE */")
gs$general_description <- "/* Use with a text entry question */"
gs$indication          <- "/* This code has to be pasted on addOnReady section */"
# CURRENT ID
gs$qid                 <- var_qid
gs$qid_num             <- "\n/* keep ID number */\nvar qid_01_num = Number(qid_01_str.replace(/^\\D+/g, ''));" # extra "\" before "\D" because "\" is a metacharacter.
# REMOVE SEPARATORS
gs$rmv_sep             <- "\n/* remove separator (if any) */\ndocument.getElementById('QID' + qid_01_num + 'Separator').style.height='0px';"
# MOVE TEXT ENRIES
set01_text <- html_codes$question_font_size %>% gsub("QUESTION_TEXT_TO_FORMAT", " % ", .) # add html format
gs$set01               <- paste0("\n/* modify text entry field */\n$('QR~' + qid_01_str).insert({after: '", set01_text, "'});")

# export to txt file
gs %>% 
  paste(., collapse = "\n") %>% 
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/gs_js.txt")

# SG response type --------------------------------------------------------
# COMMENTS
sg                     <- list(reptype_name = "/* SG RESPONSE TYPE */")
sg$general_description <- "/* Use with 4 consecutive text entry questions */"
sg$indication          <- "/* This code has to be pasted on addOnReady section */"
# CURRENT ID
sg$qid                 <- var_qid
sg$qid_num             <- "\n/* keep ID number */\nvar qid_01_num = Number(qid_01_str.replace(/^\\D+/g, ''));" # extra "\" before "\D" because "\" is a metacharacter.
# CREATE OTHER QUESTIONS ID
sg$qid_num_02          <- "var qid_02_num = qid_01_num + 1;"
sg$qid_num_03          <- "var qid_03_num = qid_01_num + 2;"
sg$qid_num_04          <- "var qid_04_num = qid_01_num + 3;"
# REMOVE SEPARATORS
sg$rmv_sep_description <- "\n/* remove separator of moved questions */"
sg$rmv_sep_01 <- "document.getElementById('QID' + qid_01_num + 'Separator').style.height='0px';"
sg$rmv_sep_02 <- "document.getElementById('QID' + qid_02_num + 'Separator').style.height='0px';"
sg$rmv_sep_03 <- "document.getElementById('QID' + qid_03_num + 'Separator').style.height='0px';"
sg$rmv_sep_04 <- "document.getElementById('QID' + qid_04_num + 'Separator').style.height='0px';"
# READ ED VALUES
sg$ed_read_description <- "\n/* read embedded data fields to fill text */"
sg$ed_read_01 <- "var positive_test_result_01 = '${e://Field/positive_test_result_01}';"
sg$ed_read_02 <- "var medical_condition_01 =  '${e://Field/medical_condition_01}';"
sg$ed_read_03 <- "var sg_person_01 =  '${e://Field/sg_person_01}';"
# MOVE TEXT ENRIES
sg$set_description_01 <- "\n/* arrange text entry 1 and 2. add text between them */"
sg$set_01 <- "$('QR~QID' + qid_01_num).insert({after: $('QR~QID' + qid_02_num)});"

set02_text <- 
  "'<span style=\"font-size:22px;\"> women receive a ' + positive_test_result_01 + ' that correctly indicates the presence of ' + medical_condition_01 + ', and </span>'"
sg$set_02 <- 
  paste0("$('QR~QID' + qid_02_num).insert({before: ",
         set02_text, #', and ',
         "});")

sg$set_description_02            <- "\n/* arrange text entry 2 and 3. add text between them */"
sg$set_03                        <- "$('QR~QID' + qid_02_num).insert({after: $('QR~QID' + qid_03_num)});"

set_04_text <- 
  "'<span style=\"font-size:22px;\">  women receive a ' + positive_test_result_01 + ' that incorrectly indicates the presence of ' + medical_condition_01 +'. Therefore, given that the ' + positive_test_result_01 + ' indicates the signs of ' + medical_condition_01 + ', the probability that ' + sg_person_01 + ' actually has ' + medical_condition_01 + ' is </span>'"
sg$set_04 <- 
  paste0("$('QR~QID' + qid_03_num).insert({before: ",
         set_04_text,
         "});")

sg$set_description_03            <- "\n/* arrange text entry 3 and 4. add text between them and at the end */"
sg$set_05                        <- "$('QR~QID' + qid_03_num).insert({after: $('QR~QID' + qid_04_num)});"

set_06_text <- 
  "'<span style=\"font-size:22px;\"> out of </span>'"
sg$set_06 <- 
  paste0("$('QR~QID' + qid_04_num).insert({before: ", 
         set_06_text, "});")
set_07_text <- 
  "'<span style=\"font-size:22px;\">.</span>'"
sg$set_07 <- 
  paste0("$('QR~QID' + qid_04_num).insert({after: ", 
         set_07_text, "});")

# export to txt file
sg %>% 
  paste(., collapse = "\n") %>% 
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/sg_js.txt")

# SS response type -------------------------------------------------------
# COMMENTS
ss                     <- list(reptype_name = "/* SS RESPONSE TYPE */")
ss$general_description <- "/* Use with 2 consecutive text entry questions */"
ss$indication          <- "/* This code has to be pasted on addOnReady section */"
# CURRENT ID
ss$qid                 <- var_qid
ss$qid_num             <- "\n/* keep ID number */\nvar qid_01_num = Number(qid_01_str.replace(/^\\D+/g, ''));" # extra "\" before "\D" because "\" is a metacharacter.
# CREATE OTHER QUESTIONS ID
ss$qid_num_02          <- "var qid_02_num = qid_01_num + 1;"
# REMOVE SEPARATORS
ss$rmv_sep_description <- "\n/* remove separator of moved questions */"
ss$rmv_sep_01 <- "document.getElementById('QID' + qid_01_num + 'Separator').style.height='0px';"
ss$rmv_sep_02 <- "document.getElementById('QID' + qid_02_num + 'Separator').style.height='0px';"
# MOVE TEXT ENRIES
ss$set_description_01 <- "\n/* arrange text entry 1 and 2. add text between them */"
ss$set_01 <- "$('QR~QID' + qid_01_num).insert({after: $('QR~QID' + qid_02_num)});"
set_02 <- 
  gsub("QUESTION_TEXT_TO_FORMAT", ' out of ', html_codes$question_font_size)

ss$set_02 <- 
  paste0("$('QR~QID' + qid_02_num).insert({before: '", set_02, "'});")

# export to txt file
ss %>% 
  paste(., collapse = "\n") %>% 
  cat(.,file = "materials/qualtrics/output/plain_text/js_codes/ss_js.txt")
