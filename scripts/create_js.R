# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse)

# create dir to output codes
dir.create("materials/qualtrics/output/plain_text/js_codes", FALSE, TRUE)

# Get current question ID. for every code.  
var_qid <- "var qid_01_str = this.questionId;" 

# GI ----------------------------------------------------------------------

paste(gsub("REPLACE_THIS", "GI RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "this script chunk only removes a question separator", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(1), sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., addOn_ready_default_js) %>% 
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/gi_resp_type.txt")

# GS response type --------------------------------------------------------

paste(gsub("REPLACE_THIS", "GS RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "give format to text entries and remove question separators", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(1),
      gsub("REPLACE_THIS", "add '%' after number", commented), 
      html_codes$question_font_size %>% 
        gsub("QUESTION_TEXT_TO_FORMAT", " % ", .) %>% 
        paste0("\n/* modify text entry field */\n$('QR~' + qid_01_str).insert({after: '", ., "'});"),
      sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., addOn_ready_default_js) %>% 
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/gs_resp_type.txt")

# SG response type --------------------------------------------------------
other_questions <- 1:3

paste(gsub("REPLACE_THIS", "SG RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "give format to text entries and remove question separators", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      get_other_questions_ID_num(other_questions),
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(4),
      gsub("REPLACE_THIS", "read embedded data fields to fill text", commented), 
      ed_read_01 <- "var positive_test_result_01 = '${e://Field/positive_test_result_01}';",
      ed_read_02 <- "var medical_condition_01 =  '${e://Field/medical_condition_01}';",
      ed_read_03 <- "var sg_person_01 =  '${e://Field/sg_person_01}';",
      gsub("REPLACE_THIS", "modify text entry fields", commented), 
      gsub("REPLACE_THIS", "arrange text entry 1 and 2. add text between them", commented), 
      "$('QR~QID' + qid_01_num).insert({after: $('QR~QID' + qid_02_num)});",
      "'<span style=\"font-size:22px;\"> women receive a ' + positive_test_result_01 + ' that correctly indicates the presence of ' + medical_condition_01 + ', and </span>'" %>% 
        paste0("$('QR~QID' + qid_02_num).insert({before: ", ., "});"),
      gsub("REPLACE_THIS", "arrange text entry 2 and 3. add text between them", commented), 
      "$('QR~QID' + qid_02_num).insert({after: $('QR~QID' + qid_03_num)});",
      "'<span style=\"font-size:22px;\">  women receive a ' + positive_test_result_01 + ' that incorrectly indicates the presence of ' + medical_condition_01 +'. Therefore, given that the ' + positive_test_result_01 + ' indicates the signs of ' + medical_condition_01 + ', the probability that ' + sg_person_01 + ' actually has ' + medical_condition_01 + ' is </span>'" %>% 
        paste0("$('QR~QID' + qid_03_num).insert({before: ", ., "});"),
      gsub("REPLACE_THIS", "arrange text entry 3 and 4. add text between them and at the end", commented), 
      "$('QR~QID' + qid_03_num).insert({after: $('QR~QID' + qid_04_num)});",
      "'<span style=\"font-size:22px;\"> out of </span>'" %>% 
        paste0("$('QR~QID' + qid_04_num).insert({before: ", ., "});"),
      "'<span style=\"font-size:22px;\">.</span>'" %>% 
        paste0("$('QR~QID' + qid_04_num).insert({after: ", ., "});"),
      sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>%
  gsub("REPLACE_THIS", ., addOn_ready_default_js) %>% 
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/sg_resp_type.txt")

# SS response type -------------------------------------------------------

paste(gsub("REPLACE_THIS", "SS RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "give format to text entries and remove question separators", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      get_other_questions_ID_num(1),
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(2),
      gsub("REPLACE_THIS", "arrange text entry 1 and 2. add text between them", commented),
      "$('QR~QID' + qid_01_num).insert({after: $('QR~QID' + qid_02_num)});",
      gsub("QUESTION_TEXT_TO_FORMAT", ' out of ', html_codes$question_font_size) %>% 
        paste0("$('QR~QID' + qid_02_num).insert({before: '", ., "'});"),
      sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., addOn_ready_default_js) %>% 
  cat(.,file = "materials/qualtrics/output/plain_text/js_codes/ss_resp_type.txt")


# Capture PPV responses ---------------------------------------------------

# SS capture PPV response -------------------------------------------------
other_questions <- 1

paste(gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
      get_id,
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      get_other_questions_ID_num(other_questions),
      gsub("REPLACE_THIS", "'Question is: QR~' + qid_01_str", consolelog),
      gsub("REPLACE_THIS", "Save current question input response", commented),
      get_response,
      get_other_questions_responses(other_questions),
      get_captured_resp_consolelog(other_questions+1),
      ss_create_ppv_response,
      assign_ppv_to_ED,
      sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., page_submit) %>%
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/ss_capture_ppv.txt")

# GI capture PPV response -------------------------------------------------
paste(
  gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
  get_id,
  gsub("REPLACE_THIS", "Get selected choice index (e.g. 1, 2, 3, etc.)", commented),
  get_selected_choice,
  gsub("REPLACE_THIS", "Convert selected choice index to text to pipe into follow-up item", commented),
  gi_create_ppv_response,
  paste0(gsub("REPLACE_THIS", "Check PPV response created", commented),
         gsub("REPLACE_THIS", "'Captured answer is: ' + ppv_response_01", consolelog)),
  assign_ppv_to_ED
  , sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., page_submit) %>% 
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/gi_capture_ppv.txt")

# SG capture PPV response -------------------------------------------------
other_questions <- 2:3

paste(gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
      get_id,
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      get_other_questions_ID_num(other_questions),
      gsub("REPLACE_THIS", "'Question is: QR~' + qid_01_str", consolelog),
      gsub("REPLACE_THIS", "Save current question input response", commented),
      get_response %>% gsub("_01_", "_03_", .),
      get_other_questions_responses(1) %>% gsub("_02_", "_04_", .),
      get_captured_resp_consolelog(2),
      ss_create_ppv_response,
      assign_ppv_to_ED,
      sep = "\n") %>%
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., page_submit) %>%
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/sg_capture_ppv.txt")

# GS capture PPV response -------------------------------------------------
paste(gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
      get_id,
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      gsub("REPLACE_THIS", "'Question is: QR~' + qid_01_str", consolelog),
      gsub("REPLACE_THIS", "Save current question input response", commented),
      get_response,
      get_captured_resp_consolelog(other_questions),
      gs_create_ppv_response,
      assign_ppv_to_ED,
      sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., page_submit) %>%
  cat(., file = "materials/qualtrics/output/plain_text/js_codes/gs_capture_ppv.txt")


