
# 
get_other_questions_ID_num <- function(other_questions) {
  # Receives a number indicating how many questions (other than the first) have to be created.
  # Outputs a chr vector
  other_questions %>% 
    map_chr(~paste0("var qid_0", .x+1, "_num = qid_01_num + ", .x, ";")) %>% 
    paste(., collapse = "\n")
}
# 
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
# 
get_captured_resp_consolelog <- function(all_questions) {
  # Receives a number indicating how many console logs have to be created to display captured responses (including the first).
  # Outputs a chr vector
  seq(all_questions) %>% 
    map_chr(~paste0("/* console.log('Captured text entry response ", .x, " is: ' + currentResponse_0", .x, ") */")) %>% 
    paste(., collapse = "\n")
}

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
ss_create_ppv_response <- 
  "\n/* Create PPV response */\nvar ppv_response_01 = currentResponse_01 + ' out of ' + currentResponse_02;\n/* console.log('ppv response is: ' + ppv_response_01); */"
assign_ppv_to_ED <- 
  "\n/* If ED exists, assign value to it. If does not exists, create it with indicated value */\nQualtrics.SurveyEngine.setEmbeddedData('ppv_response_01', ppv_response_01)"
get_selected_choice <- 
  "var selectedChoice = this.getSelectedChoices()"
gi_create_ppv_response <- 
  "if (selectedChoice == 1) {
    var ppv_response_01 = 'very few (0-20%)';
  } else if (selectedChoice == 2) {
    var ppv_response_01 = 'few (21-40%)';
  } else if (selectedChoice == 3) {
    var ppv_response_01 = 'half (41-60%)';
  } else if (selectedChoice == 4) {
    var ppv_response_01 = 'quite (61-80%)';
  } else if (selectedChoice == 5) {
    var ppv_response_01 = 'many (81-100%)';
}"

gs_create_ppv_response <- 
  "\n/* Create PPV response */\nvar ppv_response_01 = currentResponse_01 + '%';\n/* console.log('ppv response is: ' + ppv_response_01); */"

# ss
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

# gi
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

# sg
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

# gs
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