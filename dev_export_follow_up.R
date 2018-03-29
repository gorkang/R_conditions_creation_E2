
# There are 16 unique(ish) prevalences (2 contexts x 4 formats x 2 ppv prob)
# There are 2 follow-up risk (1%, 10%)
# Therefore, there are 32 possible follow-up items (e.g. ca_nfab_low_high; ppvLow_riskHigh)

# TODO: iterate through 16 prevalences and paste them into the follow-up template (1%, 10%). Use the same string where the prevalence is to get the name


item_test <- problems_numbered_ordered_responses[[10]]

item_test %>% cat

uniqchars <- function(x) unique(strsplit(x, "")[[1]]) 

response_type_regex <-
  dir("materials/Response_type/", pattern = ".txt") %>% 
  gsub("\\.txt", "", .) %>% paste(., collapse = "") %>% 
  uniqchars() %>% paste(., collapse = "")


# gsub(paste0("\\*\\*(.*)_[", response_type_regex, "]{2}\\*\\*.*"), "\\1", problems_numbered_ordered_responses)


# This snippet get only names
# unique_prevalences_names <-
#   problems_numbered_ordered_responses[seq(1, length(problems_numbered_ordered_responses), 4)] %>% 
#   map(~gsub(paste0("\\*\\*(.*)_[", response_type_regex, "]{2}\\*\\*(.*)"), "\\1\\2", .x)) %>% unlist

# names and prevalences
unique_prevalences <- 
  problems_numbered_ordered_responses[seq(1, length(problems_numbered_ordered_responses), 4)] %>% 
  map(~gsub(paste0("(\\*\\*.*)_[", response_type_regex, "]{2}(\\*\\*).*\\[first_piece\\]\\n(.*)\\n\\[second_piece\\].*"), "\\1\\2\\3", .x)) %>% unlist

# prev2followUp(unique_prevalences[[2]], "materials/Question/Follow_up/output/")

unique_prevalences %>% 
  map(~prev2followUp(prevalence_string = .x, 
                     follow_up_dir = "materials/Question/Follow_up/output/", 
                     outputdir = "materials/qualtrics/output/followUp/", rmv_placeholders = TRUE) ) %>% 
  invisible()


