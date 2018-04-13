# custom func to load files, wrapped them with html text code, and export them.
load_puthtml_export <- 
  function(x) {
    # x <- files[1]
    # load item
    item_text <- 
      readChar(con = paste0(path2fu_w_prev,x), nchars = file.info(paste0(path2fu_w_prev,x))$size)
    
    dir.create(path2fu_qualtrics_items, showWarnings = FALSE, recursive = TRUE)
    # put html tags
    cat(
      gsub("</li>\n<li>", "</li><li>",
           # replace list placeholders with html list tags
           gsub("QUESTION_TEXT_TO_FORMAT", item_text, html_codes$question_font_size)), # add font size html tags, 
      file = paste0(path2fu_qualtrics_items, x))
  }