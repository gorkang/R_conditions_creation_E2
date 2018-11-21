# For debugging ########################
# args <- c("pr", "nfab", "high", "sg")
########################################

display_item <- function(args) {
  
  # Fillers (placeholders to be filled and fillers)
  fillers <- read_csv("materials/fillers.csv", col_types = cols())
  
  # Create list with placeholders names and fillers
  set_names(list(setNames(as.list(fillers$ca), fillers$field_name),
                 setNames(as.list(fillers$pr), fillers$field_name)),
            c("ca", "pr"))
  
  # Path to txt files
  # Problem introduction
  prob_intros <- 
    "materials/qualtrics/output/plain_text/prob_intro" %>% 
    dir(., ".txt", full.names = TRUE)
  # Items
  items <- 
    "materials/qualtrics/output/plain_text/items" %>% 
    dir(., ".txt", full.names = TRUE)
  # PPV questions
  ppv_question <- 
    "materials/qualtrics/output/plain_text/ppv_question" %>% 
    dir(., ".txt", full.names = TRUE) %>% 
    readChar(., file.size(.)) %>% remove_placeholders(.)
  ## fillers to replace age and prevalence reference class on ppv question
  age_question <- 
    filter(numbers_nppi, prob == args[3]) %>% pull(age)
  prev_02_question <- 
    filter(numbers_nppi, prob == args[3]) %>% pull(prev_02)
  ## replace age and prevalence reference class
  ppv_question <-
    ppv_question %>% 
    gsub("prevalence_class_0", prev_02_question, .) %>% 
    gsub("woman_age_0", age_question, .)
  
  ppv_question <- 
    ppv_question %>% gsub("\\n___QSEP___\\n", "  \n", .)
  
  # Fill ppv question with cancer or pregnant context fillers
  medical_condition_0 <- filter(fillers, field_name == "medical_condition") %>% select(args[1]) %>% pull
  positive_test_result_0 <- filter(fillers, field_name == "positive_test_result") %>% select(args[1]) %>% pull
  sg_person_0 <- filter(fillers, field_name == "sg_person") %>% select(args[1]) %>% pull
  
  # Current problem intro
  curr_prob_intro <-
    paste(args[1], args[3], sep = "_context_ppv") %>% grep(., prob_intros, value = TRUE) %>% readChar(., file.size(.)) %>% 
    gsub("\\*\\*.*?\\*\\*", "", .)  
  
  # Current problem ppv question
  ## If presentation format is positive framework and the response type is sequential guided, keep first part of ppv question
  if ((args[2] == "pfab" & args[4] == "sg")) {
    curr_ppv_quest <-
      ppv_question %>% gsub("(\\*{2}.*)  \\nOf those.*", "\\1\n", .) %>% 
      gsub("\\$\\{e\\://Field/", "", .) %>% gsub("\\}", "", .) %>% # remove embedded data tags
      gsub("\\*\\*.*?\\*\\*", "", .)
  } else if (!(args[2] == "pfab" & args[4] == "sg")) {
    curr_ppv_quest <- 
      ppv_question %>% 
      gsub("\\$\\{e\\://Field/", "", .) %>% gsub("\\}", "", .) %>% # remove embedded data tags
      gsub("positive_test_result_0", positive_test_result_0, .) %>% 
      gsub("medical_condition_0", medical_condition_0, .) %>% 
      gsub("\\*\\*.*?\\*\\*", "", .)
  }
  
  # Current item. If item is pictorial, add image call
  if (grepl("fbpi|nppi", args[2])) {
    curr_item <- paste(args[1:3], collapse = ".*") %>% paste0("\\b", .) %>% 
      grep(., dir(path = paste0("materials/Presentation_format/", args[2], "/output"), ".png", full.names = TRUE), value = TRUE) %>% 
      paste0("![](", . ,")")
  } else if (!grepl("fbpi|nppi", args[2])) {
    curr_item <-
      paste(args[1:3], collapse = ".*") %>% grep(., items, value = TRUE) %>% readChar(., file.size(.)) %>% 
      gsub("(\\*\\*.*?\\*\\*\\n\\n)", "", .) %>% remove_placeholders() %>% gsub("\\b\\n(.*\\n\\b)", "\\1", .) %>% 
      gsub("\\n", "  \n", .)
  }
  # Define response types
  resp_types <- c(paste(c("Very few     Few      Half     Quite     Many",  "(0-20%)   (21-40%)  (41-60%)  (61-80%)   (81-100%)"), collapse = "  \n"), # gi
                  "___%", # gs
                  paste(c("____ women receive a positive test_result that correctly indicates the presence of medical_condition,",
                          "and ____ women receive a positive test_result that incorrectly indicates the presence of medical_condition.",
                          "Therefore, given that the test_result indicates the signs of medical_condition, the probability that person_01 actually has medical_condition is ____ out of ____"), 
                        collapse = "  \n"), # sg
                  "____ in every ____") #ss
  
  # Define response types names
  resp_type_nms <- c("gi", "gs", "sg", "ss")
  
  # Response type
  resp_types <- set_names(as.list(resp_types), resp_type_nms)
  
  # fill sequential guided question with problem context fillers
  resp_types$sg <- 
    resp_types$sg %>% gsub("medical_condition", medical_condition_0, .) %>% 
    gsub("test_result", positive_test_result_0, .) %>% 
    gsub("person_01", sg_person_0, .)
  
  # Display item
  paste(curr_prob_intro, curr_item, curr_ppv_quest, resp_types[[args[4]]], sep = "  \n") %>% remove_placeholders() %>% 
    paste0("**", args[1], "_", args[2], "_ppv", args[3], "**\n", .) %>% paste0(., "\n\n-------------------------\n\n") %>% 
    cat()
  
}