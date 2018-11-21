# custom func to load files, wrapped them with html text code, and export them.
load_puthtml_export <- 
  function(x) {
    # x <- files[1]
    # load item
    item_text <- 
      readChar(con = paste0("materials/Question/Follow_up/input/items/", x), nchars = file.info(paste0("materials/Question/Follow_up/input/items/", x))$size)
    
    # complete_item <- paste(item_text, paste(questions, collapse = "\n"), sep = "\n")
    # 
    # complete_item %>% cat
    # 
    # a <- 1
    # 
    # complete_item %>%
    #   gsub("/prevalence\\}", paste0("/prevalence_0", a, "\\}"), .) %>% 
    #   gsub("qualtrics_ppv_answer", paste0("qualtrics_ppv_answer_0", a), .) %>% cat
      
    
    
    
    
    
    
    dir.create(path2fu_qualtrics_items, showWarnings = FALSE, recursive = TRUE)
    # put html tags
    cat(
      gsub("</li>\n<li>", "</li><li>",
           # replace list placeholders with html list tags
           gsub("QUESTION_TEXT_TO_FORMAT", item_text, html_codes$question_font_size)), # add font size html tags, 
      file = paste0(path2fu_qualtrics_items, x))
  }