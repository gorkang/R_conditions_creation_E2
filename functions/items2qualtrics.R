items2qualtrics <- function(list_of_items, responsesdir, outputdir, removePlaceholders) {
  
  # item to format to qualtrics
  # item <- problems_numbered_ordered_responses[[1]][[1]]
  item <- 
    list_of_items
  
  # 00. get item name (this should be the actual file-name) ####
  item_name <- 
    gsub("\\*\\*(.*)\\*\\*.*", "\\1", item)
  
  # 01. get item w/o name
  item_nameless <- 
    gsub("\\*\\*.*\\*\\*\n\n(.*)", "\\1", item)
  
  
  # GET PREVALENCE NAME TO CREATE EMBEDDED DATA ########################
  prevalence_name <- 
    item_name %>% 
    gsub("([a-z]{2}_[a-z]{4}_[a-z]{6,7})_[a-z]{2}", "\\1", .)
  
  embedded_prevalence <- 
    gsub("value", 
         all_prevalences$prevalence[grep(prevalence_name, all_prevalences$name)], 
         gsub("field", "prevalence", qualtrics_codes$embedded_data))
  
  ########################################################################
  
  # 02. item without response type
  item_responseless <- 
    gsub("(.*)\\n\\[response_start\\].*", "\\1", item_nameless)
  
  
  # 03. html format (item responseless)
  html_item <- 
    gsub("\n", html_codes$linebreak,
         gsub("QUESTION_TEXT_TO_FORMAT", item_responseless, html_codes$question_font_size)
    )
  
  # 04. response type
  # hmtl_response_type <- 
  #   readChar(con = responsesdir, nchars = file.info(responsesdir)$size)
  hmtl_response_type <- 
    dir(responsesdir) %>% 
    map(~readChar(con = paste0(responsesdir, .x), nchars = file.info(paste0(responsesdir, .x))$size))
  
  # 05. Combine item elements
  if (grepl("_gi", item_name)) {
    
    item_to_export <- 
      paste(
        qualtrics_codes$advanced_format, "\n",
        qualtrics_codes$question_singlechoice_horizontal, "\n",
        html_item, "\n",
        qualtrics_codes$question_choices, "\n",
        hmtl_response_type
        
        , sep = "")
    
  } else if (!grepl("_gi", item_name)) {
    
    item_to_export <- paste(
      qualtrics_codes$advanced_format, "\n",
      qualtrics_codes$question_text, "\n",
      html_item
      
      , sep = "")
    
  }
  
  # 06. Write item to txt file
  dir.create(outputdir, showWarnings = FALSE, recursive = TRUE)
  if (removePlaceholders == TRUE) {
    cat(remove_placeholders(item_to_export), file = paste0(outputdir, item_name, ".txt"))
  } else if (removePlaceholders == FALSE) {
    cat(item_to_export, file = paste0(outputdir, item_name, ".txt"))
    
  }
  
}
