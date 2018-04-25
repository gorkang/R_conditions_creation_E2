export_qualtrics_followup_items <- function(x) {
  
  # #########################################################################
  # Possible presentation formats
  presentation_format_dir <- "materials/Presentation_format/"
  
  # grep everything without "pi" and two letter before (pictorial presentation formats)
  textual_formats <- 
    dir(presentation_format_dir) %>% grep("[a-z]{2}pi", ., invert = TRUE, value = TRUE)
  
  ## Get possible problem context
  problem_contexts <-
    textual_formats %>% 
    map(~dir(paste0(presentation_format_dir, .x, "/input")) %>% 
          gsub("([a-z]{2}).*", "\\1", .)) %>% 
    unlist %>% 
    unique %>% 
    paste(., collapse = "|")
  
  # #########################################################################
  
  # x <- item_files[1]
  x_context <- gsub(paste0(".*(", problem_contexts, ").*"), "\\1", x) # get context
  x_item <- readChar(con = paste0(path2fu_qualtrics_items,x), nchars = file.info(paste0(path2fu_qualtrics_items,x))$size) # read item
  x_item <- gsub("\\*\\*\\*.*\\*\\*\\*","", x_item) # remove name between ***name***
  
  dir.create(path2fu_qualtrics_complete_items, showWarnings = FALSE, recursive = TRUE)
  
  if (x_context == "ca") {
    
    cat(qualtrics_codes$advanced_format, "\n",
        qualtrics_codes$question_only_text, "\n",
        gsub("\n", html_codes$linebreak, x_item), "\n",
        gsub("risk_percentage", 
             gsub(".*([0-9]{2}%).*", "\\1", x_item), 
             gsub("medical_condition", "breast cancer", paste(questions, collapse = "\n"))),
        sep = ""
        , file = paste0(path2fu_qualtrics_complete_items, x)
    )
  } else if (x_context == "pr") {
    
    cat(qualtrics_codes$advanced_format, "\n",
        qualtrics_codes$question_only_text, "\n",
        gsub("\n", html_codes$linebreak, x_item), "\n",
        gsub("risk_percentage", 
             gsub(".*([0-9]{2}%).*", "\\1", x_item), 
             gsub("medical_condition", "Trisomy 21", paste(questions, collapse = "\n"))),
        sep = ""
        , file = paste0(path2fu_qualtrics_complete_items, x)
    )
  }
  
}