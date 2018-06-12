# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse)

# create dir to output codes
dir.create("materials/qualtrics/output/plain_text/js_codes", FALSE, TRUE)

# Get current question ID. for every code. 
var_qid <- "var qid = this.questionId;"

# GS response type --------------------------------------------------------
reptype_name <- "/* GS RESPONSE TYPE */"

gs_description <- "/* Use with a text entry question */"

percent_add <- "$('QR~' + qid).insert({after: ' %'});"

cat(reptype_name, gs_description, var_qid, percent_add, sep = "\n", 
    file = "materials/qualtrics/output/plain_text/js_codes/gs_js.txt")

# SG response type --------------------------------------------------------
reptype_name <- "/* SG RESPONSE TYPE */"

gs_description <- "/* Use with a form question (4 fields) */"

sg <- list(var01 = NULL)

sg$var01 <- 'var positive_test_result_01 = "${e://Field/positive_test_result_01}";'
sg$var02 <- 'var medical_condition_01 =  "${e://Field/medical_condition_01}";'
sg$var03 <- 'var sg_person_01 =  "${e://Field/sg_person_01}";'

sg$sQ01 <- "var QSG01 = '1';"
sg$sQ02 <- "var QSG02 = '2';"
sg$sQ03 <- "var QSG03 = '3';"
sg$sQ04 <- "var QSG04 = '4';"

sg$set01 <- "$('QR~' + qid + '~' + QSG01).insert({after: $('QR~' + qid + '~' + QSG02)});"
sg$set02 <- "$('QR~' + qid + '~' + QSG02).insert({before: '  women receive a ' + positive_test_result_01 + ' that correctly indicates the presence of ' + medical_condition_01 + ', and '});"
sg$set03 <- "$('QR~' + qid + '~' + QSG02).insert({after: $('QR~' + qid + '~' + QSG03)});"
sg$set04 <- "$('QR~' + qid + '~' + QSG03).insert({before: '  women receive a ' + positive_test_result_01 + ' that incorrectly indicates the presence of ' + medical_condition_01 + '. Therefore, given that the '+ positive_test_result_01 + ' indicates the signs of ' + medical_condition_01 + ', the probability that ' + sg_person_01 + ' actually has ' + medical_condition_01 + ' is ' });"
sg$set05 <- "$('QR~' + qid + '~' + QSG03).insert({after: $('QR~' + qid + '~' + QSG04)});"
sg$set06 <- "$('QR~' + qid + '~' + QSG04).insert({before: ' out of '});"
sg$set07 <- "$('QR~' + qid + '~' + QSG04).insert({after: '.'});"

paste(sg, collapse = "\n") %>% 
  cat(reptype_name, gs_description, var_qid, ., sep = "\n", 
      file = "materials/qualtrics/output/plain_text/js_codes/sg_js.txt")

# SS response type -------------------------------------------------------
reptype_name <- "/* SS RESPONSE TYPE */"
ss_description <- "/* Use with a form question (2 fields) */"
ss <- list(sQ01 = NULL)

ss$sQ01 <- "var QSS01 = '1';"
ss$sQ02 <- "var QSS02 = '2';"

ss$setQ01 <- "$('QR~' + qid + '~' + QSS01).insert({after: $('QR~' + qid + '~' + QSS02)});"
ss$setQ02 <- "$('QR~' + qid + '~' + QSS02).insert({before: ' out of '});"

paste(ss, collapse = "\n") %>% 
  cat(reptype_name, ss_description, var_qid, ., sep = "\n", 
      file = "materials/qualtrics/output/plain_text/js_codes/ss_js.txt")