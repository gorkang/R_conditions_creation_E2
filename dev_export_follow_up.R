
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



prev2followUp <- function(prevalence_string, follow_up_dir) {
  
  # this_prev <- unique_prevalences[[2]]
  this_prev <- prevalence_string
  this_prev_nameless <- gsub("\\*\\*.*\\*\\*(.*)", "\\1", this_prev)
  this_prev_name <- gsub("\\*\\*(.*)\\*\\*.*", "\\1", this_prev)
  this_prev_context <- gsub("\\*\\*(ca).*|\\*\\*(pr).*", "\\1\\2", this_prev)
  this_prev_ppvProb <- gsub(".*(high).*|.*(low).*", "\\1\\2", this_prev)
  this_prev_format <- gsub(".*(nfab|pfab|prab|prre).*", "\\1", this_prev)
  
  # sumsample follow-up items by context
  # followUp_dir <- "materials/Question/Follow_up/output/"
  followUp_dir <- follow_up_dir
  followUp_files <- paste0(followUp_dir,dir(followUp_dir, pattern = ".txt"))
  followUps_paths <- grep(this_prev_context, followUp_files, value = TRUE)
  followUps_items <- followUps_paths %>% map(~readChar(.x, nchars = file.info(.x)$size))
  
  # replace prevalence placeholder with this prevalence
  followUps_items %>% 
    gsub("prevalence_and_context", this_prev_nameless, .) %>%
    gsub("(\\*\\*\\*.*)(\\*\\*\\*)(.*)", paste0("\\1_ppv", this_prev_ppvProb, "_", this_prev_format, "\\2\\3"), .)
  
}


prev2followUp(unique_prevalences[[2]], "materials/Question/Follow_up/output/")

unique_prevalences %>% 
  map(~prev2followUp(prevalence_string = .x, follow_up_dir = "materials/Question/Follow_up/output/")) %>% 
  unlist() %>% as.list() 


# %>% gsub("\\*\\*\\*(.*)\\*\\*\\*.*", "\\1", .) %>% invisible(cat(paste(., collapse = "\n")))

