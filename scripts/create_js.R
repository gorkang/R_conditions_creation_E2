# Packages
if (!require('pacman')) install.packages('pacman'); library('pacman')
p_load(tidyverse, magrittr)

# create dir to output codes
js_output_dir <- 
  "materials/qualtrics/output/plain_text/js_codes/partial" %T>% 
  dir.create(., FALSE, TRUE)

# Functions ---------------------------------------------------------------

# GET OTHER QUESTIONS ID: feed a number to create other questions numeric ID. the lines of code generated work only if the first numeric ID was generated previously.
get_other_questions_ID_num <- function(other_questions) {
  # Receives a number indicating how many questions (other than the first) have to be created.
  # Outputs a chr vector
  other_questions %>% 
    map_chr(~paste0("var qid_0", .x+1, "_num = qid_01_num + ", .x, ";")) %>% 
    paste(., collapse = "\n")
}
# GET OTHER QUESTIONS RESPONSES: feed a number to capture responses (text-entry) of other questions. It is not necessary to capture the first question response previously.
get_other_questions_responses <- function(other_questions) {
  # Receives a number indicating how many responses (other than the first) have to be captured
  # Outputs a chr vector
  seq(other_questions) %>% 
    map_chr(~paste0(
      "var responseTextField_0", 
      .x+1, " = document.getElementById('QR~QID' + qid_0", 
      .x+1, "_num);\nvar currentResponse_0", 
      .x+1, " = responseTextField_0", .x+1, ".value;")) %>% 
    paste(., collapse = "\n")
}
# GET CAPTURED RESPONSES CONSOLE LOG: create console log calls to display captured responses.
get_captured_resp_consolelog <- function(all_questions) {
  # Receives a number indicating how many console logs have to be created to display captured responses (including the first).
  # Outputs a chr vector
  seq(all_questions) %>% 
    map_chr(~paste0("/* console.log('Captured text entry response ", .x, " is: ' + currentResponse_0", .x, ") */")) %>% 
    paste(., collapse = "\n")
}
# REMOVE SEPARATORS: create lines to remove the number of separators feeded. It is necessary to previously create the numeric ID of the questions to remove their separators.
remove_separators <- function(all_questions) {
  # Receives a number indicating how many console logs have to be created to display captured responses (including the first).
  # Outputs a chr vector
  seq(all_questions) %>% 
    map_chr(~paste0("document.getElementById('QID' + qid_0", .x, "_num + 'Separator').style.height='0px';")) %>% 
    paste(., collapse = "\n")
}

# Templates ---------------------------------------------------------------
# Get current question ID. for every code.  
var_qid <- "var qid_01_str = this.questionId;" 
# General
page_submit <- 
  "Qualtrics.SurveyEngine.addOnPageSubmit(function()\n{\n\nREPLACE_THIS\n\n});"
commented <- 
  "\n/* REPLACE_THIS */"
get_id <- 
  "var qid_01_str = this.questionId;"
get_id_num <- 
  "var qid_01_num = Number(qid_01_str.replace(/^\\\\D+/g, ''));" # extra / because it's a metacharacter
consolelog <- # by default console logs are commented
  "\n/* console.log(REPLACE_THIS) */"
get_response <- 
  "var responseTextField_01 = document.getElementById('QR~QID' + qid_01_num);\nvar currentResponse_01 = responseTextField_01.value;"
assign_ppv_to_ED <- 
  "\n/* If ED exists, assign value to it. If does not exists, create it with indicated value */\nQualtrics.SurveyEngine.setEmbeddedData('ppv_response_0', ppv_response_0)"
# Get responses
get_selected_choice <- 
  "var selectedChoice = this.getSelectedChoices()"
ss_create_ppv_response <- 
  "\n/* Create PPV response */\nvar ppv_response_0 = currentResponse_01 + ' out of ' + currentResponse_02;\n/* console.log('ppv response is: ' + ppv_response_0); */"
gi_create_ppv_response <- 
  "if (selectedChoice == 1) {
    var ppv_response_0 = 'very few (0-20%)';
  } else if (selectedChoice == 2) {
    var ppv_response_0 = 'few (21-40%)';
  } else if (selectedChoice == 3) {
    var ppv_response_0 = 'half (41-60%)';
  } else if (selectedChoice == 4) {
    var ppv_response_0 = 'quite (61-80%)';
  } else if (selectedChoice == 5) {
    var ppv_response_0 = 'many (81-100%)';
}"
gs_create_ppv_response <- 
  "\n/* Create PPV response */\nvar ppv_response_0 = currentResponse_01 + '%';\n/* console.log('ppv response is: ' + ppv_response_0); */"

# Qualtrics JS templates
addOn_ready <- 
  "Qualtrics.SurveyEngine.addOnReady(function()\n{\n\nREPLACE_THIS\n\n});"
addOn_default_js <- 
  "Qualtrics.SurveyEngine.addOnload(function()\n{\n	/*Place your JavaScript here to run when the page loads*/\n\n});\n\nQualtrics.SurveyEngine.addOnReady(function()\n{\n	/*Place your JavaScript here to run when the page is fully displayed*/\n\n});\n\nQualtrics.SurveyEngine.addOnUnload(function()\n{\n	/*Place your JavaScript here to run when the page is unloaded*/\n\n});\n"
addOn_ready_default_js <- 
  "Qualtrics.SurveyEngine.addOnload(function()\n{\n	/*Place your JavaScript here to run when the page loads*/\n\n});\n\nQualtrics.SurveyEngine.addOnReady(function()\n{\n	/*Place your JavaScript here to run when the page is fully displayed*/\n\nREPLACE_THIS\n\n});\n\nQualtrics.SurveyEngine.addOnUnload(function()\n{\n	/*Place your JavaScript here to run when the page is unloaded*/\n\n});\n"
addOn_unload_default_js <- 
  "Qualtrics.SurveyEngine.addOnload(function()\n{\n	/*Place your JavaScript here to run when the page loads*/\n\n});\n\nQualtrics.SurveyEngine.addOnReady(function()\n{\n	/*Place your JavaScript here to run when the page is fully displayed*/\n\n});\n\nQualtrics.SurveyEngine.addOnUnload(function()\n{\n	/*Place your JavaScript here to run when the page is unloaded*/\nREPLACE_THIS\n\n});\n"

# Give format according to response type ----------------------------------

# GI response type ----------------------------------------------------------------------

paste(gsub("REPLACE_THIS", "GI RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "this script chunk only removes a question separator", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "'Question ID: ' + qid_01_str", consolelog),
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      gsub("REPLACE_THIS", "'Question ID number: ' + qid_01_num", consolelog),
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(1), sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., addOn_ready_default_js) %>% 
  cat(., file = file.path(js_output_dir, "gi_resp_type.txt"))

# GS response type --------------------------------------------------------

paste(gsub("REPLACE_THIS", "GS RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "give format to text entries and remove question separators", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "'Question ID: ' + qid_01_str", consolelog),
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      gsub("REPLACE_THIS", "'Question ID number: ' + qid_01_num", consolelog),
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(1),
      gsub("REPLACE_THIS", "add '%' after number", commented), 
      html_codes$question_font_size %>% 
        gsub("QUESTION_TEXT_TO_FORMAT", " % ", .) %>% 
        paste0("\n/* modify text entry field */\n$('QR~' + qid_01_str).insert({after: '", ., "'});"),
      sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., addOn_ready_default_js) %>% 
  cat(., file = file.path(js_output_dir, "gs_resp_type.txt"))

# SG response type --------------------------------------------------------
other_questions <- 1:3

paste(gsub("REPLACE_THIS", "SG RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "give format to text entries and remove question separators", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "'Question ID: ' + qid_01_str", consolelog),
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      get_other_questions_ID_num(other_questions),
      gsub("REPLACE_THIS", "'Question ID number: ' + qid_01_num", consolelog),
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(4),
      gsub("REPLACE_THIS", "read embedded data fields to fill text", commented), 
      ed_read_01 <- "var positive_test_result = '${e://Field/positive_test_result_0}';",
      ed_read_02 <- "var medical_condition =  '${e://Field/medical_condition_0}';",
      ed_read_03 <- "var sg_person =  '${e://Field/sg_person_0}';",
      gsub("REPLACE_THIS", "modify text entry fields", commented), 
      gsub("REPLACE_THIS", "arrange text entry 1 and 2. add text between them", commented), 
      "$('QR~QID' + qid_01_num).insert({after: $('QR~QID' + qid_02_num)});",
      "'<span style=\"font-size:22px;\"> women receive a ' + positive_test_result + ' that correctly indicates the presence of ' + medical_condition + ', and </span>'" %>% 
        paste0("$('QR~QID' + qid_02_num).insert({before: ", ., "});"),
      gsub("REPLACE_THIS", "arrange text entry 2 and 3. add text between them", commented), 
      "$('QR~QID' + qid_02_num).insert({after: $('QR~QID' + qid_03_num)});",
      "'<span style=\"font-size:22px;\">  women receive a ' + positive_test_result + ' that incorrectly indicates the presence of ' + medical_condition +'. Therefore, given that the ' + positive_test_result + ' indicates the signs of ' + medical_condition + ', the probability that ' + sg_person + ' actually has ' + medical_condition + ' is </span>'" %>% 
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
  cat(., file = file.path(js_output_dir, "sg_resp_type.txt"))

# SS response type -------------------------------------------------------

paste(gsub("REPLACE_THIS", "SS RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "give format to text entries and remove question separators", commented),
      gsub("REPLACE_THIS", "get question ID", commented),
      var_qid,
      gsub("REPLACE_THIS", "'Question ID: ' + qid_01_str", consolelog),
      gsub("REPLACE_THIS", "Get questions IDs (e.g. 10, 11, 12, etc.)", commented),
      get_id_num,
      get_other_questions_ID_num(1),
      gsub("REPLACE_THIS", "'Question ID number: ' + qid_01_num", consolelog),
      gsub("REPLACE_THIS", "remove separator(s) if any", commented), 
      remove_separators(2),
      gsub("REPLACE_THIS", "arrange text entry 1 and 2. add text between them", commented),
      "$('QR~QID' + qid_01_num).insert({after: $('QR~QID' + qid_02_num)});",
      gsub("QUESTION_TEXT_TO_FORMAT", ' out of ', html_codes$question_font_size) %>% 
        paste0("$('QR~QID' + qid_02_num).insert({before: '", ., "'});"),
      sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., addOn_ready_default_js) %>% 
  cat(., file = file.path(js_output_dir, "ss_resp_type.txt"))


# Capture PPV responses ---------------------------------------------------

# SS capture PPV response -------------------------------------------------
other_questions <- 1

paste(gsub("REPLACE_THIS", "SS RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
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
  cat(., file = file.path(js_output_dir, "ss_capture_ppv.txt"))

# GI capture PPV response -------------------------------------------------
paste(
  gsub("REPLACE_THIS", "GI RESPONSE TYPE", commented),
  gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
  get_id,
  gsub("REPLACE_THIS", "Get selected choice index (e.g. 1, 2, 3, etc.)", commented),
  get_selected_choice,
  gsub("REPLACE_THIS", "Convert selected choice index to text to pipe into follow-up item", commented),
  gi_create_ppv_response,
  paste0(gsub("REPLACE_THIS", "Check PPV response created", commented),
         gsub("REPLACE_THIS", "'Captured answer is: ' + ppv_response_0", consolelog)),
  assign_ppv_to_ED
  , sep = "\n") %>% 
  gsub("\n", "\n   ", .) %>% 
  gsub("REPLACE_THIS", ., page_submit) %>% 
  cat(., file = file.path(js_output_dir, "gi_capture_ppv.txt"))
# SG capture PPV response -------------------------------------------------
other_questions <- 2:3

paste(gsub("REPLACE_THIS", "SG RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
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
  cat(., file = file.path(js_output_dir, "sg_capture_ppv.txt"))

# GS capture PPV response -------------------------------------------------
paste(gsub("REPLACE_THIS", "GS RESPONSE TYPE", commented),
      gsub("REPLACE_THIS", "Get current question ID (e.g. QID10)", commented),
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
  cat(., file = file.path(js_output_dir, "gs_capture_ppv.txt"))


# WILLING TO SCREEN - How strongly would you recommend her (NOT) to take the screening test? -----

# This JS code captures the response (should she take the test?) and creates 
# and embedded data field with either an empty space or a "NOT" to put in the following question

# If statement to create text to put on ED field
cap_ans_will <- 
  "   if (selectedChoice_0 == 1) {
     var should_she_0 = '';
   } else if (selectedChoice_0 == 2) {
     var should_she_0 = 'NOT';
   }"

# Create JS code 
should_she <- 
  paste(
  gsub("REPLACE_THIS", "Should she take the screening test?", commented),
  gsub("REPLACE_THIS", "Get selected choice index (1 = Yes, 2 = No)", commented),
  "var selectedChoice_0 = this.getSelectedChoices()",
  gsub("REPLACE_THIS", "Create ED field according to response of \"should she take the screening test?\"", commented),
  cap_ans_will,
  gsub("REPLACE_THIS", "Check response captured", commented),
  gsub("REPLACE_THIS", "'Should she take the test?: ' + should_she_0", consolelog),
  gsub("REPLACE_THIS", "If ED exists, assign value to it. If does not exists, create it with indicated value", commented),
  "Qualtrics.SurveyEngine.setEmbeddedData('should_she_0', should_she_0)",
  gsub("REPLACE_THIS", "'Embedded data is: ' + Qualtrics.SurveyEngine.gettEmbeddedData('should_she_0')", consolelog), 
  sep = "\n") %>% 
  gsub("REPLACE_THIS", ., page_submit) %>% 
  paste(addOn_default_js, .) 

# Add trial number to vars
should_she <- 
  1:2 %>% 
  map(~gsub("(_0)\\b", paste0("\\1", .x), should_she) %>% 
        gsub("(\\*\\*[a-z]{2})(\\*\\*.*)", paste0("\\1_0", .x, "\\2"), .)) %>% 
  unlist()

# ######################
js_comp_output_dir <- 
  "materials/qualtrics/output/plain_text/js_codes/complete" %T>% 
  dir.create(., FALSE, TRUE)
# ######################

# Export to text, one per block
should_she %>% paste0(paste0("**will_should_she_0", 1:2, "**"), .) %>% 
  walk(~cat(gsub("\\*{2}will_should_she_0[12]\\*{2}(.*)", "\\1", .x), 
            file = file.path(js_comp_output_dir, paste0(gsub("\\*\\*(will_should_she_0[12])\\*\\*.*", "\\1", .x), "_js_complete.txt"))))
  
# Append JS codes ---------------------------------------------------------

# paste js codes
all_js_complete <- 
  dir(js_output_dir, ".txt") %>% 
  gsub("([a-z]{2}).*", "\\1", .) %>% 
  unique() %>% 
  # read js codes files
  map(~
        grep(., dir(js_output_dir, ".txt"), value = TRUE) %>% 
        rev() %>% 
        file.path(js_output_dir, .) %>% 
        map_chr(~readChar(.x, file.size(.x))) %>% 
        paste0(., collapse = "\n\n") %>% 
        paste0("**", .x, "**", .)
      
  )

# add trial indicator to embedded data fields reading
all_js_complete <- 
  1:2 %>% 
  map(~gsub("(_0)\\b", paste0("\\1", .x), all_js_complete) %>% 
        gsub("(\\*\\*[a-z]{2})(\\*\\*.*)", paste0("\\1_0", .x, "\\2"), .)) %>% unlist()

# export to txt file
all_js_complete %>% 
  walk(~cat(gsub("\\*\\*[a-z]{2}_0[12]\\*\\*(.*)", "\\1", .x), 
            file = file.path(js_comp_output_dir, paste0(gsub("\\*\\*([a-z]{2}_0[12])\\*\\*.*", "\\1", .x), "_js_complete.txt"))))



