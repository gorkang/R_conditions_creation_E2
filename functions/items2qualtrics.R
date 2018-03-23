items2qualtrics <- function(list_of_items, inputdir, outputdir) {
  
  # item to format to qualtrics
  # item <- problems_numbered_ordered_responses[[1]][[1]]
  # inputdir <- input_dir
  # outputdir <- output_dir
  item <- list_of_items
  
  # 00. get item name (this should be the actual file-name) ####
  item_name <- gsub("\\*\\*(.*)\\*\\*.*", "\\1", item)
  
  # 01. get item w/o name
  item_nameless <- gsub("\\*\\*.*\\*\\*\n\n(.*)", "\\1", item)
  
  # separate problem context, actual item, and question from response type. ####
  # if all items end with five breaklines (\n) it can be use to chop-off the response type.
  # it seems that it is the case.
  # lapply(problems_numbered_ordered_responses, 
  #        function(x) {lapply(x, 
  #                            function(x) {if (grep("\n\n\n\n\n", lapply(x, function(y) {y})) != 1) {print("NOOOOOOOO")}})})
  
  # 02. item without response type
  item_responseless <- gsub("(.*)\n\n\n\n\n.*", "\\1", item_nameless)
  
  # remove extra linebreaks
  # regex to select everything but extra breaklines
  regex_pattern_breaklines <- "(^.*\\n\\n.*\\n\\n.*\\n)\\n(.*\\n)\\n(.*\\n\\n)\\n(.*$)"
  # remove extra breaklines
  item_responseless <- gsub(regex_pattern_breaklines, "\\1\\2\\3\\4", item_responseless)
  
  # 03. Item (without response type)
  html_item_responseless <- gsub("QUESTION_TEXT_TO_FORMAT", item_responseless, html_codes$question_font_size)
  html_item_responseless_breaks <- gsub("\n", html_codes$linebreak, html_item_responseless)
  
  # 04. response type
  # Global intuitive response type
  hmtl_response_type <- readChar(con = inputdir, nchars = file.info(inputdir)$size)
  
  # 05. Combine item elements
  
  if (grepl("_gi", item_name)) {
    
    item_to_export <- paste(
      qualtrics_codes$advanced_format, "\n",
      qualtrics_codes$singlechoice_horizontal, "\n",
      html_item_responseless_breaks, "\n",
      qualtrics_codes$question_choices, "\n",
      hmtl_response_type
      
      , sep = "")
    
    
  } else if (!grepl("_gi", item_name)) {
    
    item_to_export <- paste(
      qualtrics_codes$advanced_format, "\n",
      qualtrics_codes$question_text, "\n",
      html_item_responseless_breaks
      
      , sep = "")
    
  }
  
  # 06. Write item to txt file
  dir.create(outputdir, showWarnings = FALSE, recursive = TRUE)
  cat(item_to_export, file = paste0(outputdir, item_name, ".txt"))
  
}
