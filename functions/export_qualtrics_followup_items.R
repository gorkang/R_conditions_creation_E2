export_qualtrics_followup_items <- function(x) {
  
  # x <- item_files[1]
  x_context <- gsub("-*(ca|pr).*", "\\1", x) # get context
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